#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
ALL_COMPONENTS=(niri noctalia ghostty nvim zsh starship fastfetch elx tutors)

PLATFORM=""
DRY_RUN=false
ASSUME_YES=false
INSTALL_PACKAGES=true
INSTALL_EXTRAS=true
UNINSTALL=false
COMPONENTS_ARG=""
REPOSITORY_MODE=ask
USE_ADDITIONAL_REPOS=false
BACKUP_DIR="${HOME}/.local/state/dotfiles-backups/$(date +%Y%m%d-%H%M%S)"
BACKUP_USED=false

declare -A SELECTED=()
declare -a INSTALLED=()
declare -a SKIPPED=()
declare -a BACKED_UP=()

usage() {
	cat <<'EOF'
Usage: ./install.sh [options]

Interactive installer for this Artix/Arch Linux desktop setup.

Options:
  --platform arch|artix      Select the package source explicitly
  --components LIST         Comma-separated components or "all"
  --no-packages             Only deploy configuration files
  --no-extras               Skip source builds and third-party tools
  --with-repositories       Configure raf and protected Arch repositories
  --without-repositories    Keep Pacman configuration unchanged
  --dry-run                 Print actions without changing the system
  --yes, -y                 Accept defaults and confirmations
  --uninstall               Remove only symlinks created by this repository
  --help, -h                Show this help

Components:
  niri noctalia ghostty nvim zsh starship fastfetch elx tutors

Examples:
  ./install.sh
  ./install.sh --platform artix --yes
  ./install.sh --components nvim,zsh,starship --no-packages
  ./install.sh --dry-run --components all
  ./install.sh --uninstall --components nvim,zsh
EOF
}

log() {
	printf '\033[1;34m==>\033[0m %s\n' "$*"
}

warn() {
	printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2
}

die() {
	printf '\033[1;31merror:\033[0m %s\n' "$*" >&2
	exit 1
}

print_command() {
	printf '  '
	printf '%q ' "$@"
	printf '\n'
}

run() {
	print_command "$@"
	if ! $DRY_RUN; then
		"$@"
	fi
}

confirm() {
	local prompt=$1
	if $ASSUME_YES; then
		return 0
	fi
	local answer
	read -r -p "$prompt [y/N] " answer
	[[ $answer == [yY] || $answer == [yY][eE][sS] ]]
}

contains_component() {
	local wanted=$1 component
	for component in "${ALL_COMPONENTS[@]}"; do
		[[ $component == "$wanted" ]] && return 0
	done
	return 1
}

parse_args() {
	while (($#)); do
		case $1 in
			--platform)
				(($# >= 2)) || die "--platform requires arch or artix"
				PLATFORM=$2
				shift 2
				;;
			--components)
				(($# >= 2)) || die "--components requires a list"
				COMPONENTS_ARG=$2
				shift 2
				;;
			--no-packages)
				INSTALL_PACKAGES=false
				shift
				;;
			--no-extras)
				INSTALL_EXTRAS=false
				shift
				;;
			--with-repositories)
				REPOSITORY_MODE=yes
				shift
				;;
			--without-repositories)
				REPOSITORY_MODE=no
				shift
				;;
			--dry-run)
				DRY_RUN=true
				shift
				;;
			--yes|-y)
				ASSUME_YES=true
				shift
				;;
			--uninstall)
				UNINSTALL=true
				INSTALL_PACKAGES=false
				INSTALL_EXTRAS=false
				shift
				;;
			--help|-h)
				usage
				exit 0
				;;
			*) die "unknown option: $1" ;;
		esac
	done
}

choose_repositories() {
	$UNINSTALL && return 0

	case $REPOSITORY_MODE in
		yes) USE_ADDITIONAL_REPOS=true ;;
		no) USE_ADDITIONAL_REPOS=false ;;
		ask)
			if ! $INSTALL_PACKAGES; then
				USE_ADDITIONAL_REPOS=false
			elif $ASSUME_YES; then
				USE_ADDITIONAL_REPOS=true
			else
				local answer
				if [[ $PLATFORM == artix ]]; then
					read -r -p "Configure raf and protected Arch [extra] repositories? [Y/n] " answer
				else
					read -r -p "Configure the raf package repository? [Y/n] " answer
				fi
				[[ $answer != [nN] && $answer != [nN][oO] ]] && USE_ADDITIONAL_REPOS=true
			fi
			;;
	esac
	return 0
}

register_raf_key() {
	local fingerprint=8180ACCD03D345F7681D2D37DDCE5997AEB9743D
	local key_url=https://github.com/rozeraf/raf-repo/releases/download/x86_64/rozeraf-repo-key.asc

	confirm "Download and locally trust the raf repository signing key?" || {
		warn "raf key registration skipped; signed raf packages cannot be installed until the key is trusted"
		return 0
	}

	log "register raf repository signing key"
	if $DRY_RUN; then
		print_command curl -fL -o rozeraf-repo-key.asc "$key_url"
		print_command gpg --show-keys --with-colons rozeraf-repo-key.asc
		print_command sudo pacman-key --add rozeraf-repo-key.asc
		print_command sudo pacman-key --lsign-key "$fingerprint"
		return 0
	fi

	local key_dir key_file downloaded_fingerprint
	key_dir=$(mktemp -d)
	key_file="$key_dir/rozeraf-repo-key.asc"
	curl -fL -o "$key_file" "$key_url"
	downloaded_fingerprint=$(gpg --show-keys --with-colons "$key_file" 2>/dev/null | \
		awk -F: '$1 == "fpr" { print $10; exit }')
	if [[ $downloaded_fingerprint != "$fingerprint" ]]; then
		rm -rf -- "$key_dir"
		die "raf signing key fingerprint mismatch: expected $fingerprint, got ${downloaded_fingerprint:-none}"
	fi
	sudo pacman-key --add "$key_file"
	sudo pacman-key --lsign-key "$fingerprint"
	rm -rf -- "$key_dir"
}

configure_repositories() {
	$USE_ADDITIONAL_REPOS || return 0
	local repository_file="$SCRIPT_DIR/pacman/repositories-$PLATFORM.conf"
	local rendered
	rendered=$(mktemp)

	log "configure Pacman repositories for $PLATFORM"
	if [[ $PLATFORM == artix ]]; then
		print_command sudo pacman -Syu --needed artix-archlinux-support
		if ! $DRY_RUN; then
			pacman -Si artix-archlinux-support >/dev/null 2>&1 || die "Artix repository does not provide artix-archlinux-support"
			sudo pacman -Syu --needed --noconfirm artix-archlinux-support
		fi
		run sudo install -Dm644 "$SCRIPT_DIR/pacman/hooks/00-block-systemd.hook" "/etc/pacman.d/hooks/00-block-systemd.hook"
	fi
	register_raf_key

	if [[ $PLATFORM == artix ]]; then
		awk -f "$SCRIPT_DIR/pacman/strip-managed-repositories.awk" /etc/pacman.conf > "$rendered"
		printf '\n' >> "$rendered"
		awk '1' "$repository_file" >> "$rendered"
	else
		awk -v repository_file="$repository_file" \
			-f "$SCRIPT_DIR/pacman/insert-raf-before-extra.awk" \
			/etc/pacman.conf > "$rendered"
	fi

	if cmp -s "$rendered" /etc/pacman.conf; then
		SKIPPED+=("/etc/pacman.conf")
	else
		log "back up /etc/pacman.conf -> $BACKUP_DIR/etc/pacman.conf"
		if ! $DRY_RUN; then
			mkdir -p -- "$BACKUP_DIR/etc"
			cp -- /etc/pacman.conf "$BACKUP_DIR/etc/pacman.conf"
		fi
		BACKUP_USED=true
		BACKED_UP+=("/etc/pacman.conf")
		run sudo install -Dm644 "$rendered" /etc/pacman.conf
		INSTALLED+=("/etc/pacman.conf")
	fi
	rm -f -- "$rendered"
	run sudo pacman -Syy
}

detect_platform() {
	[[ -r /etc/os-release ]] || die "cannot read /etc/os-release"
	# shellcheck disable=SC1091
	source /etc/os-release
	case ${ID:-} in
		arch) printf 'arch\n' ;;
		artix) printf 'artix\n' ;;
		*) printf '\n' ;;
	esac
}

choose_platform() {
	local detected
	detected=$(detect_platform)

	if [[ -n $PLATFORM ]]; then
		[[ $PLATFORM == arch || $PLATFORM == artix ]] || die "unsupported platform: $PLATFORM"
		return
	fi

	if $ASSUME_YES && [[ -n $detected ]]; then
		PLATFORM=$detected
		return
	fi

	printf '\nSelect package source:\n'
	local arch_label="" artix_label=""
	if [[ $detected == arch ]]; then arch_label=" (detected)"; fi
	if [[ $detected == artix ]]; then artix_label=" (detected)"; fi
	printf '  1) Arch Linux%s\n' "$arch_label"
	printf '  2) Artix Linux%s\n' "$artix_label"
	local choice
	read -r -p "Choice [${detected:-none}]: " choice
	case $choice in
		1|arch) PLATFORM=arch ;;
		2|artix) PLATFORM=artix ;;
		"")
			if [[ -n $detected ]]; then
				PLATFORM=$detected
			else
				die "platform selection is required"
			fi
			;;
		*) die "invalid platform selection" ;;
	esac
}

select_components() {
	local input component index
	if [[ -n $COMPONENTS_ARG ]]; then
		input=$COMPONENTS_ARG
	elif $ASSUME_YES; then
		input=all
	else
		printf '\nComponents:\n'
		for index in "${!ALL_COMPONENTS[@]}"; do
			printf '  %d) %s\n' "$((index + 1))" "${ALL_COMPONENTS[index]}"
		done
		read -r -p "Select numbers/names separated by commas [all]: " input
		input=${input:-all}
	fi

	if [[ $input == all ]]; then
		for component in "${ALL_COMPONENTS[@]}"; do
			SELECTED[$component]=1
		done
		return
	fi

	IFS=',' read -ra choices <<< "$input"
	for component in "${choices[@]}"; do
		component=${component//[[:space:]]/}
		if [[ $component =~ ^[0-9]+$ ]] && ((component >= 1 && component <= ${#ALL_COMPONENTS[@]})); then
			component=${ALL_COMPONENTS[component - 1]}
		fi
		contains_component "$component" || die "unknown component: $component"
		SELECTED[$component]=1
	done
	((${#SELECTED[@]})) || die "no components selected"

	# Starship and its repository-managed config are part of the Zsh setup.
	if [[ ${SELECTED[zsh]:-} ]]; then
		SELECTED[starship]=1
	fi
}

add_unique() {
	local array_name=$1 value=$2 current
	local -n array_ref=$array_name
	for current in "${array_ref[@]:-}"; do
		[[ $current == "$value" ]] && return
	done
	array_ref+=("$value")
}

resolve_packages() {
	REPO_PACKAGES=(base-devel git curl ca-certificates)
	AUR_PACKAGES=()

	if [[ ${SELECTED[niri]:-} ]]; then
		for package in niri xdg-desktop-portal xdg-desktop-portal-gtk xwayland-satellite wl-clipboard; do
			add_unique REPO_PACKAGES "$package"
		done
		add_unique AUR_PACKAGES zen-browser-bin
	fi

	if [[ ${SELECTED[noctalia]:-} ]]; then
		for package in brightnessctl playerctl cliphist imagemagick jq pipewire wireplumber polkit grim slurp tesseract tesseract-data-eng; do
			add_unique REPO_PACKAGES "$package"
		done
		if [[ $PLATFORM == arch || $USE_ADDITIONAL_REPOS == true ]]; then
			add_unique REPO_PACKAGES noctalia
		else
			add_unique AUR_PACKAGES noctalia-git
		fi
	fi

	if [[ ${SELECTED[ghostty]:-} ]]; then
		for package in ghostty otf-monaspace-nerd ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji; do
			add_unique REPO_PACKAGES "$package"
		done
	fi

	if [[ ${SELECTED[nvim]:-} ]]; then
		for package in neovim clang uv; do
			add_unique REPO_PACKAGES "$package"
		done
		command -v cargo >/dev/null 2>&1 || add_unique REPO_PACKAGES rust
		if pacman -Si bun >/dev/null 2>&1; then
			add_unique REPO_PACKAGES bun
		else
			add_unique AUR_PACKAGES bun-bin
		fi
	fi

	if [[ ${SELECTED[zsh]:-} ]]; then
		for package in zsh fzf zoxide ripgrep fd bat zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting; do
			add_unique REPO_PACKAGES "$package"
		done
	fi

	[[ ${SELECTED[starship]:-} ]] && add_unique REPO_PACKAGES starship

	if [[ ${SELECTED[fastfetch]:-} ]]; then
		for package in fastfetch jq; do add_unique REPO_PACKAGES "$package"; done
		if $USE_ADDITIONAL_REPOS; then
			add_unique REPO_PACKAGES wallfetch
			add_unique REPO_PACKAGES desktop-stack
		else
			command -v cargo >/dev/null 2>&1 || add_unique REPO_PACKAGES rust
		fi
	fi

	if [[ ${SELECTED[elx]:-} ]]; then
		if $USE_ADDITIONAL_REPOS; then
			add_unique REPO_PACKAGES elx
		elif ! command -v cargo >/dev/null 2>&1; then
			add_unique REPO_PACKAGES rust
		fi
	fi

	if [[ ${SELECTED[tutors]:-} ]]; then
		add_unique REPO_PACKAGES clang
		add_unique REPO_PACKAGES make
	fi

	if ((${#AUR_PACKAGES[@]})) && ! command -v paru >/dev/null 2>&1 && ! command -v cargo >/dev/null 2>&1; then
		add_unique REPO_PACKAGES rust
	fi
}

verify_repo_packages() {
	local package missing=()
	for package in "${REPO_PACKAGES[@]}"; do
		pacman -Si "$package" >/dev/null 2>&1 || missing+=("$package")
	done
	if ((${#missing[@]})); then
		die "$PLATFORM repositories do not currently provide: ${missing[*]}. Check enabled repositories before continuing."
	fi
}

install_repo_packages() {
	log "$PLATFORM repository packages (${#REPO_PACKAGES[@]}):"
	print_command sudo pacman -Syu --needed "${REPO_PACKAGES[@]}"
	confirm "Install these repository packages?" || {
		warn "repository package installation skipped"
		return
	}
	# A repository configured during a dry run is not yet visible to pacman.
	# Existing repositories can and should still be validated.
	if $DRY_RUN && $USE_ADDITIONAL_REPOS; then
		return 0
	fi
	verify_repo_packages
	run sudo pacman -Syu --needed --noconfirm "${REPO_PACKAGES[@]}"
}

ensure_paru() {
	command -v paru >/dev/null 2>&1 && return
	log "paru is required for AUR packages"
	local build_dir="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/paru"
	if $DRY_RUN; then
		print_command git clone https://aur.archlinux.org/paru.git "$build_dir"
		print_command makepkg -si --needed --noconfirm
		return
	fi
	rm -rf -- "$build_dir"
	mkdir -p -- "$(dirname -- "$build_dir")"
	git clone https://aur.archlinux.org/paru.git "$build_dir"
	(
		cd -- "$build_dir"
		makepkg -si --needed --noconfirm
	)
}

install_aur_packages() {
	((${#AUR_PACKAGES[@]})) || return 0
	log "AUR packages for $PLATFORM (${#AUR_PACKAGES[@]}):"
	print_command paru -S --needed "${AUR_PACKAGES[@]}"
	confirm "Build and install these AUR packages?" || {
		warn "AUR package installation skipped"
		return
	}
	ensure_paru
	if ! $DRY_RUN; then
		local package missing=()
		for package in "${AUR_PACKAGES[@]}"; do
			paru -Si "$package" >/dev/null 2>&1 || missing+=("$package")
		done
		((${#missing[@]} == 0)) || die "AUR does not currently provide: ${missing[*]}"
	fi
	run paru -S --needed --noconfirm "${AUR_PACKAGES[@]}"
}

relative_link_target() {
	local source=$1 target=$2
	realpath -m --relative-to="$(dirname -- "$target")" "$source"
}

link_path() {
	local source=$1 target=$2 relative current
	[[ -e $source || -L $source ]] || die "missing repository path: $source"
	relative=$(relative_link_target "$source" "$target")

	if [[ -L $target ]]; then
		current=$(readlink -- "$target")
		if [[ $current == "$relative" ]] || [[ $(realpath -m -- "$(dirname -- "$target")/$current") == $(realpath -m -- "$source") ]]; then
			SKIPPED+=("$target")
			return
		fi
	fi

	if [[ -e $target || -L $target ]]; then
		local backup_relative=${target#"$HOME"/}
		local backup="$BACKUP_DIR/$backup_relative"
		log "back up $target -> $backup"
		if ! $DRY_RUN; then
			mkdir -p -- "$(dirname -- "$backup")"
			mv -- "$target" "$backup"
		fi
		BACKUP_USED=true
		BACKED_UP+=("$target")
	fi

	if $DRY_RUN; then
		print_command mkdir -p "$(dirname -- "$target")"
		print_command ln -s "$relative" "$target"
	else
		mkdir -p -- "$(dirname -- "$target")"
		ln -s -- "$relative" "$target"
	fi
	INSTALLED+=("$target")
}

unlink_path() {
	local source=$1 target=$2
	if [[ -L $target ]] && [[ $(realpath -m -- "$target") == $(realpath -m -- "$source") ]]; then
		run rm -- "$target"
		INSTALLED+=("removed $target")
	else
		SKIPPED+=("$target")
	fi
}

deploy_component() {
	local component=$1 action=link_path
	$UNINSTALL && action=unlink_path
	case $component in
		niri)
			$action "$SCRIPT_DIR/niri/config.kdl" "$HOME/.config/niri/config.kdl"
			$action "$SCRIPT_DIR/niri/noctalia.kdl" "$HOME/.config/niri/noctalia.kdl"
			;;
		noctalia)
			$action "$SCRIPT_DIR/noctalia/settings.toml" "$HOME/.config/noctalia/settings.toml"
			if ! $UNINSTALL; then run mkdir -p "$HOME/Pictures/Wallpapers"; fi
			;;
		ghostty)
			$action "$SCRIPT_DIR/ghostty/config" "$HOME/.config/ghostty/config"
			$action "$SCRIPT_DIR/ghostty/gtk.css" "$HOME/.config/ghostty/gtk.css"
			$action "$SCRIPT_DIR/ghostty/themes/noctalia" "$HOME/.config/ghostty/themes/noctalia"
			;;
		nvim)
			$action "$SCRIPT_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
			$action "$SCRIPT_DIR/nvim/lua" "$HOME/.config/nvim/lua"
			;;
		zsh)
			$action "$SCRIPT_DIR/zsh/.zshrc" "$HOME/.zshrc"
			$action "$SCRIPT_DIR/zsh/aliases.zsh" "$HOME/.config/zsh/aliases.zsh"
			$action "$SCRIPT_DIR/zsh/functions.zsh" "$HOME/.config/zsh/functions.zsh"
			;;
		starship)
			$action "$SCRIPT_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
			;;
		fastfetch)
			$action "$SCRIPT_DIR/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
			$action "$SCRIPT_DIR/wallfetch/config.toml" "$HOME/.config/wallfetch/config.toml"
			$action "$SCRIPT_DIR/wallfetch/template" "$HOME/.config/wallfetch/template"
			;;
		elx)
			$action "$SCRIPT_DIR/elx/config.toml" "$HOME/.config/elx/config.toml"
			;;
		tutors) ;;
	esac
}

ensure_repo() {
	local url=$1 directory=$2
	if [[ -d $directory/.git ]]; then
		run git -C "$directory" pull --ff-only
	elif [[ -e $directory ]]; then
		die "$directory exists but is not a Git repository"
	else
		run git clone "$url" "$directory"
	fi
}

install_source_tools() {
	local projects_dir=${PROJECTS_DIR:-$HOME/projects}

	if [[ ${SELECTED[fastfetch]:-} ]] && ! $USE_ADDITIONAL_REPOS; then
		ensure_repo https://github.com/rozeraf/wallfetch.git "$projects_dir/wallfetch"
		run make -C "$projects_dir/wallfetch" PREFIX="$HOME/.local" install

		ensure_repo https://github.com/rozeraf/desktop-stack.git "$projects_dir/desktop-stack"
		run cargo build --release --manifest-path "$projects_dir/desktop-stack/Cargo.toml"
		run install -Dm755 "$projects_dir/desktop-stack/target/release/desktop-stack" "$HOME/.local/bin/desktop-stack"
	fi

	if [[ ${SELECTED[elx]:-} ]] && ! $USE_ADDITIONAL_REPOS; then
		ensure_repo https://github.com/rozeraf/elx.git "$projects_dir/elx"
		run make -C "$projects_dir/elx" install
	fi

	if [[ ${SELECTED[tutors]:-} ]]; then
		ensure_repo https://github.com/rozeraf/tutors.git "$projects_dir/tutors"
		run make -C "$projects_dir/tutors" PREFIX="$HOME/.local" install
	fi

	if [[ ${SELECTED[nvim]:-} ]]; then
		if $DRY_RUN || command -v uv >/dev/null 2>&1; then run uv tool install black; fi
		if $DRY_RUN || command -v cargo >/dev/null 2>&1; then run cargo install --locked stylua; fi
		if $DRY_RUN || command -v bun >/dev/null 2>&1; then run bun add --global prettier; fi
	fi
}

install_zsh_integrations() {
	[[ ${SELECTED[zsh]:-} ]] || return 0
	ensure_repo https://github.com/Aloxaf/fzf-tab.git "$HOME/.local/share/zsh/fzf-tab"
}

set_default_shell() {
	[[ ${SELECTED[zsh]:-} ]] || return 0
	$UNINSTALL && return 0
	command -v zsh >/dev/null 2>&1 || return 0
	[[ ${SHELL:-} == "$(command -v zsh)" ]] && return 0
	confirm "Set Zsh as the login shell for ${USER:-$(id -un)}?" || return 0
	run chsh -s "$(command -v zsh)"
}

print_summary() {
	printf '\n\033[1mSummary\033[0m\n'
	printf '  platform: %s\n' "$PLATFORM"
	printf '  changed:  %d\n' "${#INSTALLED[@]}"
	printf '  skipped:  %d\n' "${#SKIPPED[@]}"
	printf '  backups:  %d\n' "${#BACKED_UP[@]}"
	if $BACKUP_USED; then
		printf '  backup directory: %s\n' "$BACKUP_DIR"
	fi
	if ! $UNINSTALL; then
		printf '\nLog out and select the Niri session to start the desktop.\n'
	fi
}

main() {
	parse_args "$@"
	[[ $EUID -ne 0 ]] || die "run this installer as a regular user, not root"
	choose_platform
	select_components
	choose_repositories

	log "platform: $PLATFORM"
	log "components: ${!SELECTED[*]}"
	log "additional repositories: $USE_ADDITIONAL_REPOS"
	$DRY_RUN && warn "dry-run mode: no changes will be made"

	if ! $UNINSTALL; then
		configure_repositories
	fi

	if $INSTALL_PACKAGES && ! $UNINSTALL; then
		resolve_packages
		install_repo_packages
		install_aur_packages
		install_zsh_integrations
	fi

	local component
	for component in "${ALL_COMPONENTS[@]}"; do
		[[ ${SELECTED[$component]:-} ]] && deploy_component "$component"
	done

	if $INSTALL_EXTRAS && ! $UNINSTALL; then
		confirm "Install/update source-built tools and integrations?" && install_source_tools
	fi

	set_default_shell
	print_summary
}

main "$@"
