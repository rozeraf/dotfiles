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
├── fastfetch/    Fastfetch config and dynamic logo template
├── ghostty/      Ghostty terminal config, GTK styling, and generated theme
├── niri/         Niri compositor and Noctalia integration
├── noctalia/     Noctalia user settings
├── nvim/         Neovim config managed with lazy.nvim
├── starship/     Starship prompt
├── zsh/          Zsh startup, aliases, and functions
└── elx/          elx file-listing config
```

These are personal files, not a universal installer. Review paths and settings before linking them into `~/.config`.

## Fastfetch

The Fastfetch config depends on two small external utilities:

- [`desktop-stack`](https://github.com/rozeraf/desktop-stack) detects the active compositor, desktop shell, bar, and related services.
- [`wallfetch`](https://github.com/rozeraf/wallfetch) extracts an ordered palette from the current Noctalia wallpaper and renders the five-color ANSI logo.

Install both before using `fastfetch/config.jsonc`:

```bash
git clone https://github.com/rozeraf/desktop-stack.git ~/projects/desktop-stack
cargo build --release --manifest-path ~/projects/desktop-stack/Cargo.toml
sudo install -Dm755 ~/projects/desktop-stack/target/release/desktop-stack /usr/local/bin/desktop-stack

git clone https://github.com/rozeraf/wallfetch.git ~/projects/wallfetch
make -C ~/projects/wallfetch PREFIX="$HOME/.local" install
```

Then link or copy the config and logo template:

```bash
mkdir -p ~/.config/fastfetch
ln -sfn "$PWD/fastfetch/config.jsonc" ~/.config/fastfetch/config.jsonc
ln -sfn "$PWD/fastfetch/logo" ~/.config/fastfetch/logo
```

The config intentionally remains strict JSON despite the `.jsonc` extension. Noctalia's Fastfetch community template merges generated UI colors with `jq`, so comments and trailing commas would break theme updates. Dependency links therefore live here rather than as comments in the config.

Fastfetch calls both tools through command modules:

```text
fastfetch
├── wallfetch → wallpaper hash → cached ANSI logo in /tmp
└── desktop-stack → cached desktop/session description
```

Noctalia may continue updating title, key, and percentage colors. Logo colors bypass that generated palette and come directly from the wallpaper through `wallfetch`.

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
