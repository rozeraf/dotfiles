# dotfiles

Personal configuration files for Arch Linux + Hyprland.

## Stack

- **OS**: Arch Linux
- **WM**: Hyprland (end-4 dotfiles)
- **Shell**: zsh + Oh My Zsh + Starship
- **Editor**: Neovim
- **Terminal**: Kitty
- **Package managers**: pacman / paru / bun

## Structure

```
dotfiles/
├── nvim/
│   └── init.lua          # Neovim config (Lazy.nvim)
├── nvimtutor/
│   ├── nvimtutor.c       # Interactive Neovim cheatsheet
│   └── Makefile
├── zsh/
│   ├── .zshrc
│   ├── aliases.zsh
│   ├── functions.zsh
│   └── network.zsh
└── README.md
```

## Neovim

Requires Neovim >= 0.10. Plugins are managed by [Lazy.nvim](https://github.com/folke/lazy.nvim) and install automatically on first launch.

**Plugins:**

| Plugin | Purpose |
|---|---|
| catppuccin-mocha | colorscheme |
| telescope.nvim | fuzzy finder, project search |
| oil.nvim | file manager as a buffer |
| grug-far.nvim | project-wide search & replace (ripgrep) |
| nvim-treesitter | syntax highlighting, indentation |
| nvim-lspconfig + mason | LSP (lua, python, typescript) |
| conform.nvim | format on save (prettier, stylua, black) |
| leap.nvim | jump anywhere on screen |
| vim-surround | surround text objects |
| vim-commentary | toggle comments |
| targets.vim | extended text objects |
| vim-fugitive | Git integration |
| noice.nvim | improved UI for messages and LSP |
| which-key.nvim | keybinding hints |
| lualine.nvim | statusline |
| fidget.nvim | LSP progress indicator |
| vim-illuminate | highlight word under cursor |

**Key mappings (leader = Space):**

```
-             open oil (parent directory)
<leader>ff    find files
<leader>fg    live grep (search in project)
<leader>fb    buffers
<leader>fr    recent files
<leader>sr    search & replace (word under cursor)
<leader>sR    search & replace (empty)
<leader>y/p   yank/paste to system clipboard
<leader>d     cut to system clipboard
```

## nvimtutor

Interactive terminal cheatsheet for Neovim keybindings and plugins.

```zsh
cd dotfiles/nvimtutor
make
sudo make install      # installs to /usr/local/bin/nvimtutor
```

Then run anywhere:

```zsh
nvimtutor
```

Covers: navigation, editing, text objects, search & replace, buffers/windows, project/directory workflow, plugins, LSP, Telescope.

## zsh

**Plugins:** git, zsh-autosuggestions, zsh-syntax-highlighting, fzf-tab, history-substring-search, you-should-use, sudo, dirhistory, copypath, jsontools

**Notable aliases:**

```zsh
i               sudo pacman -S --needed
pget            paru -S
fnvim           fzf | xargs nvim  (fuzzy open file in nvim)
tree            eza --tree --icons
ll              eza -la --icons
cat             bat
grep            rg
find            fd
z               zoxide (smart cd)
```

**Functions:**

| Function | Description |
|---|---|
| `backup [file\|dir]` | create timestamped backup as `.tar.gz` |
| `weather [city]` | weather via wttr.in (default: Almaty) |
| `ports [n]` | list listening ports, or specific port |
| `killport <n>` | kill process on port |
| `myip` | show external and local IP |
| `ccmd <cmd>` | run command and copy output to clipboard |
| `qr <text>` | generate QR code in terminal |
| `nhn [dir]` | open Nautilus in background |

## Dependencies

Install all at once:

```zsh
i base-devel neovim git ripgrep fd fzf eza bat zoxide starship \
  ttf-nerd-fonts-symbols-common wl-clipboard
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```
