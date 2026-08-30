# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for Arch Linux + Hyprland / Niri. Components:

- `niri/` — Niri scrollable tiling compositor config
- `nvim/` — Neovim config (`init.lua`, Lazy.nvim plugin manager)
- `zsh/` — zsh config (`.zshrc`, `aliases.zsh`, `functions.zsh`, `network.zsh`)
- `kitty/` — Kitty terminal config
- `starship/` — Starship prompt config

## Build & Install

### Neovim

Plugins install automatically via Lazy.nvim on first launch. Requires Neovim >= 0.10.

## Architecture Notes

### Neovim (`nvim/init.lua`)

Single-file config. Structure:
1. Lazy.nvim bootstrap
2. Global options (`vim.opt.*`)
3. Global keymaps (leader = Space)
4. `require("lazy").setup({...})` — all plugins defined inline

Key behavior: `d`/`x`/`dd` delete to void register (not clipboard); `<leader>d` cuts to system clipboard. This is intentional.

### zsh

`.zshrc` sources the other files. `aliases.zsh` overrides system commands: `cat`→`bat`, `grep`→`rg`, `find`→`fd`, `ls`→`lsd`.

## Dependencies

```zsh
sudo pacman -S base-devel neovim git ripgrep fd fzf lsd bat zoxide starship \
  ttf-nerd-fonts-symbols-common wl-clipboard
```
