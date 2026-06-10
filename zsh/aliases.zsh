# ~/.config/zsh/aliases.zsh

# ── Documentation ────────────────────────────────────────────────────
alias aliases='nvim ~/.config/zsh/aliases.zsh'

# ── Config editors ───────────────────────────────────────────────────
alias hypr='nvim ~/.config/hypr/'
alias bashrc='nvim ~/.bashrc'
alias zshrc='nvim ~/.zshrc'

# ── Torrent ──────────────────────────────────────────────────────────
alias torrent='qbittorrent'

# ── File tools ───────────────────────────────────────────────────────
alias ls='elx'
alias la='elx -la'
alias ll='elx -l'
alias tree='elx --tree'
alias fnvim='fzf --preview "bat --color=always {}" | xargs nvim'

# ── Navigation ───────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ── Misc ─────────────────────────────────────────────────────────────
alias nvimconfig='nvim ~/.config/nvim/init.lua'

# ── Package management ───────────────────────────────────────────────
alias i='sudo pacman -S --needed'

# ── Zoxide ───────────────────────────────────────────────
alias zi='zoxide query -i'
