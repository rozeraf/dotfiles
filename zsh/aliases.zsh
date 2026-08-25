# ~/.config/zsh/aliases.zsh

# ── File tools ───────────────────────────────────────────────────────
alias ls='elx'
alias la='elx -la'
alias ll='elx -l'
alias tree='elx --tree'

# ── Navigation ───────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ── Package management ───────────────────────────────────────────────
alias i='sudo pacman -S --needed'

# ── Zoxide ───────────────────────────────────────────────
alias zi='zoxide query -i'
