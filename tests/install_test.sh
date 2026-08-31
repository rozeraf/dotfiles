#!/usr/bin/env bash

set -euo pipefail

REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
TEST_ROOT=$(mktemp -d)
trap 'rm -rf -- "$TEST_ROOT"' EXIT

fail() {
	printf 'FAIL: %s\n' "$*" >&2
	exit 1
}

run_installer() {
	HOME=$TEST_ROOT "$REPO_DIR/install.sh" \
		--platform artix \
		--components starship \
		--no-packages \
		--no-extras \
		--yes \
		"$@"
}

printf 'test: clean install\n'
run_installer >/dev/null
target="$TEST_ROOT/.config/starship.toml"
[[ -L $target ]] || fail "starship config was not linked"
[[ $(realpath -- "$target") == "$REPO_DIR/starship/starship.toml" ]] || fail "link points to the wrong source"

printf 'test: repeated install\n'
output=$(run_installer)
[[ $output == *"skipped:  1"* ]] || fail "repeated install was not skipped"

printf 'test: conflicting file backup\n'
rm -- "$target"
printf 'local config\n' > "$target"
run_installer >/dev/null
[[ -L $target ]] || fail "conflicting file was not replaced with a link"
backup=$(find "$TEST_ROOT/.local/state/dotfiles-backups" -type f -name starship.toml -print -quit)
[[ -n $backup ]] || fail "conflicting file was not backed up"
[[ $(<"$backup") == "local config" ]] || fail "backup content changed"

printf 'test: dry run\n'
rm -- "$target"
HOME=$TEST_ROOT "$REPO_DIR/install.sh" \
	--platform artix \
	--components starship \
	--no-packages \
	--no-extras \
	--dry-run \
	--yes >/dev/null
[[ ! -e $target && ! -L $target ]] || fail "dry run changed the target"

printf 'test: uninstall\n'
run_installer >/dev/null
run_installer --uninstall >/dev/null
[[ ! -e $target && ! -L $target ]] || fail "uninstall did not remove the managed link"

printf 'test: missing repository dependency\n'
fake_bin="$TEST_ROOT/fake-bin"
mkdir -p -- "$fake_bin"
printf '#!/usr/bin/env bash\nexit 1\n' > "$fake_bin/pacman"
chmod +x "$fake_bin/pacman"
if PATH="$fake_bin:$PATH" HOME=$TEST_ROOT "$REPO_DIR/install.sh" \
	--platform artix \
	--components starship \
	--dry-run \
	--without-repositories \
	--no-extras \
	--yes >/dev/null 2>&1; then
	fail "missing repository dependency was not detected"
fi

printf 'test: additional repository package plan\n'
output=$(HOME=$TEST_ROOT "$REPO_DIR/install.sh" \
	--platform artix \
	--components noctalia,fastfetch,elx \
	--with-repositories \
	--dry-run \
	--yes)
[[ $output == *"artix-archlinux-support"* ]] || fail "Artix compatibility support was not planned"
[[ $output == *"00-block-systemd.hook"* ]] || fail "systemd protection hook was not planned"
[[ $output == *"rozeraf-repo-key.asc"* ]] || fail "raf signing key download was not planned"
[[ $output == *"pacman-key --add"* ]] || fail "raf signing key import was not planned"
[[ $output == *"pacman-key --lsign-key 8180ACCD03D345F7681D2D37DDCE5997AEB9743D"* ]] || \
	fail "raf signing key trust was not planned"
for package in noctalia wallfetch desktop-stack elx; do
	[[ $output == *" $package"* ]] || fail "$package repository package was not planned"
done
[[ $output != *"noctalia-git"* ]] || fail "repository mode retained the Noctalia AUR fallback"

printf 'test: fallback package plan\n'
output=$(HOME=$TEST_ROOT "$REPO_DIR/install.sh" \
	--platform artix \
	--components noctalia,fastfetch,elx \
	--without-repositories \
	--dry-run \
	--yes)
[[ $output == *"noctalia-git"* ]] || fail "Noctalia AUR fallback was not planned"
[[ $output == *"github.com/rozeraf/wallfetch.git"* ]] || fail "wallfetch source fallback was not planned"
[[ $output == *"github.com/rozeraf/desktop-stack.git"* ]] || fail "desktop-stack source fallback was not planned"
[[ $output == *"github.com/rozeraf/elx.git"* ]] || fail "elx source fallback was not planned"

printf 'test: interactive repository decline\n'
output=$(printf 'n\ny\ny\n' | HOME=$TEST_ROOT "$REPO_DIR/install.sh" \
	--platform artix \
	--components tutors \
	--dry-run)
[[ $output == *"additional repositories: false"* ]] || fail "repository decline did not select fallback mode"
[[ $output == *"github.com/rozeraf/tutors.git"* ]] || fail "repository decline did not continue to tutors source build"

printf 'test: optional zsh integrations\n'
grep -Fq '[[ -r "$HOME/.local/share/zsh/fzf-tab/fzf-tab.plugin.zsh" ]]' "$REPO_DIR/zsh/.zshrc" || \
	fail "fzf-tab is sourced without an existence check"
grep -Fq 'if (( $+commands[starship] )); then' "$REPO_DIR/zsh/.zshrc" || \
	fail "Starship is initialized without a command check"

printf 'test: complete Zsh component plan\n'
output=$(HOME=$TEST_ROOT "$REPO_DIR/install.sh" \
	--platform artix \
	--components zsh \
	--without-repositories \
	--no-extras \
	--dry-run \
	--yes)
[[ $output == *" starship"* ]] || fail "Zsh component did not include the Starship package"
[[ $output == *"$REPO_DIR/starship/starship.toml"* ]] || fail "Zsh component did not deploy the Starship config"
[[ $output == *"github.com/Aloxaf/fzf-tab.git"* ]] || fail "Zsh component did not clone fzf-tab"

printf 'PASS\n'
