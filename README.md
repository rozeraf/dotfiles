# dotfiles

Personal configuration for an Artix/Arch Linux desktop built around Niri and Noctalia Shell.

## Current stack

- **OS:** Artix Linux (Arch-compatible packages)
- **Compositor:** Niri
- **Desktop shell:** Noctalia Shell
- **Shell:** Zsh with Starship
- **Terminal:** Ghostty
- **Editor:** Neovim
- **CLI tools:** `elx`, `fzf`, `ripgrep`, `fd`, `bat`, `zoxide`

## Repository layout

```text
dotfiles/
├── install.sh    Interactive Arch/Artix bootstrap and linker
├── fastfetch/    Fastfetch config
├── ghostty/      Ghostty terminal config, GTK styling, and generated theme
├── niri/         Niri compositor and Noctalia integration
├── noctalia/     Noctalia user settings
├── nvim/         Neovim config managed with lazy.nvim
├── starship/     Starship prompt
├── wallfetch/    Independent palette provider config and template
├── tests/        Isolated installer tests
├── zsh/          Zsh startup, aliases, and functions
└── elx/          elx file-listing config
```

These remain opinionated personal settings. Review display, wallpaper, and
application-specific values before deploying them to a different machine.

## Installation

The interactive installer supports both Arch Linux and Artix Linux. It asks
which platform and components to install, shows package commands before
running them, backs up conflicting files, and creates relative symbolic links.

```bash
git clone https://github.com/rozeraf/dotfiles.git ~/projects/dotfiles
cd ~/projects/dotfiles
./install.sh
```

Arch and Artix use separate package plans. In particular, Arch installs
Noctalia from `[extra]`, while Artix builds `noctalia-git` from the AUR with
`paru`. If `paru` is missing, the installer bootstraps it from its AUR
PKGBUILD after installing `base-devel` and Git.

The full setup includes Niri, Noctalia, Ghostty, Neovim, Zsh, Starship,
Fastfetch, fonts and Wayland utilities. It can also clone, build, and install
`elx`, `wallfetch`, `desktop-stack`, `fzf-tab`, and the three programs from
[`rozeraf/tutors`](https://github.com/rozeraf/tutors). User-built binaries are
installed into `~/.local/bin`.

Useful modes:

```bash
./install.sh --dry-run
./install.sh --platform artix --yes
./install.sh --components nvim,zsh,starship --no-packages
./install.sh --components fastfetch,elx,tutors
```

### Updating

Pull this repository and run the installer again. Correct links are left
untouched; source-built projects are updated with a fast-forward-only pull.

```bash
git pull --ff-only
./install.sh
```

### Backups and recovery

The installer never silently overwrites an existing path. Conflicts are moved
to a timestamped directory under `~/.local/state/dotfiles-backups/`, and that
directory is printed in the final summary. To recover a file, remove its new
symlink and move the corresponding backup back into place.

### Uninstalling links

Uninstall mode removes only symlinks that still point into this checkout. It
does not remove packages, source repositories, user data, or unrelated files.

```bash
./install.sh --uninstall --components all --yes
```

Run `./install.sh --help` for all options.

## Fastfetch

The Fastfetch config depends on two small external utilities:

- [`desktop-stack`](https://github.com/rozeraf/desktop-stack) detects the active compositor, desktop shell, bar, and related services.
- [`wallfetch`](https://github.com/rozeraf/wallfetch) independently extracts an ordered wallpaper palette; Fastfetch consumes its formatted template output.

Install both before using `fastfetch/config.jsonc`:

```bash
git clone https://github.com/rozeraf/desktop-stack.git ~/projects/desktop-stack
cargo build --release --manifest-path ~/projects/desktop-stack/Cargo.toml
install -Dm755 ~/projects/desktop-stack/target/release/desktop-stack ~/.local/bin/desktop-stack

git clone https://github.com/rozeraf/wallfetch.git ~/projects/wallfetch
make -C ~/projects/wallfetch PREFIX="$HOME/.local" install
```

Then link or copy the consumer config and the independent wallfetch config:

```bash
mkdir -p ~/.config/fastfetch
ln -sfn "$PWD/fastfetch/config.jsonc" ~/.config/fastfetch/config.jsonc
mkdir -p ~/.config/wallfetch
ln -sfn "$PWD/wallfetch/config.toml" ~/.config/wallfetch/config.toml
ln -sfn "$PWD/wallfetch/template" ~/.config/wallfetch/template
```

The config intentionally remains strict JSON despite the `.jsonc` extension. Noctalia's Fastfetch community template merges generated UI colors with `jq`, so comments and trailing commas would break theme updates. Dependency links therefore live here rather than as comments in the config.

Fastfetch calls both tools through command modules:

```text
wallpaper → wallfetch colors → reusable palette
                              └── template → wallfetch render → Fastfetch
desktop session → desktop-stack → Fastfetch
```

Noctalia may continue updating title, key, and percentage colors. The rendered template bypasses that generated palette and comes from the independent `wallfetch` pipeline. Both commands are resolved through `PATH`, so packages installed in `/usr/bin` and local builds installed in `~/.local/bin` work without config changes.

## Shell

The Zsh configuration does not use Oh My Zsh. It loads system packages directly:

- zsh-autosuggestions;
- zsh-history-substring-search;
- zsh-syntax-highlighting;
- fzf and fzf-tab;
- zoxide;
- Starship.

Notable aliases:

```text
ff       fastfetch
vide     neovide
ls       elx
la       elx -la
ll       elx -l
tree     elx --tree
i        sudo pacman -S
zi       interactive zoxide query
```

## Neovim

Neovim is configured as a lightweight editor for quick changes rather than a
second IDE. Plugins are managed by
[lazy.nvim](https://github.com/folke/lazy.nvim) and split into small modules.
The setup keeps Oil, simple buffer/path completion, formatting, sessions,
ToggleTerm, Alpha, Which-key, Noice, Catppuccin, and a compact set of editing
helpers. It intentionally has no LSP, Mason, Treesitter plugin, project search,
Git integration, or file-tree sidebar.

Main mappings use `Space` as leader:

```text
-             open Oil
<leader>a     open Alpha dashboard
<leader>bd    close buffer
<leader>1..9  switch buffer
<leader>tf    floating terminal
d/y/x/p       use the system clipboard
```

## Tutors

The interactive terminal cheatsheets previously stored here now live in the
separate [`rozeraf/tutors`](https://github.com/rozeraf/tutors) repository.

## Base dependencies

Typical packages for this setup:

```bash
sudo pacman -S --needed base-devel git neovim zsh starship fastfetch \
  ripgrep fd fzf bat zoxide wl-clipboard ghostty \
  zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting \
  ttf-nerd-fonts-symbols-common
```

Niri, Noctalia, `elx`, AUR helpers, language servers, and optional development tools are intentionally installed separately.
