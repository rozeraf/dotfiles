# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for an Artix/Arch Linux desktop built around Niri and
Noctalia. Components:

- `niri/` — Niri scrollable tiling compositor config
- `noctalia/` — Noctalia user settings
- `nvim/` — Neovim config (`init.lua`, Lazy.nvim plugin manager)
- `zsh/` — Zsh config (`.zshrc`, `aliases.zsh`, `functions.zsh`)
- `ghostty/` — Ghostty terminal config, GTK CSS, and Noctalia theme
- `fastfetch/` — Fastfetch config and wallpaper-derived logo
- `elx/` — elx file-listing config
- `starship/` — Starship prompt config

## Build & Install

### Neovim

Plugins install automatically via Lazy.nvim on first launch. The configuration
targets Neovim 0.12 or newer.

## Architecture Notes

### Neovim (`nvim/`)

`init.lua` is a small entry point. Core options, keymaps, highlights, and the
VS Code compatibility spec live in `lua/config/`; each plugin group lives in a
separate `lua/plugins/` module loaded through Lazy's `import` mechanism.

The setup is deliberately a lightweight editor, not an IDE. Do not add LSP,
Mason, Treesitter plugins, project-wide search, Git frontends, or file-tree
sidebars unless explicitly requested.

Key behavior: normal `d`, `y`, `x`, and `p` operations use the system clipboard.
Other operators, including `c` and `s`, retain normal Vim register behavior.

### zsh

`.zshrc` sources `aliases.zsh` and `functions.zsh`. File-listing aliases use
`elx`; the shell also initializes fzf-tab, zoxide, Starship, autosuggestions,
history substring search, and syntax highlighting.

## Dependencies

```zsh
sudo pacman -S base-devel neovim git ripgrep fd fzf bat zoxide starship \
  fastfetch ghostty ttf-nerd-fonts-symbols-common wl-clipboard
```
