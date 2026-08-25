# ~/.config/zsh/aliases.zsh

# Fastfetch
alias ff="fastfetch"

# File tools
alias ls='elx'
alias la='elx -la'
alias ll='elx -l'
alias tree='elx --tree'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Package management
alias i='sudo pacman -S'

# Zoxide
alias zi='zoxide query -i'

# >>> 7DAY_GUARD_TEMP_LINE >>>
if (( $(date +%s) < 1788215525 )); then
  alias pswd="cat ~/projects/cpp-pswd-gen/password.txt"
fi
# <<< 7DAY_GUARD_TEMP_LINE <<<

source "$HOME/.config/zsh/.week_phrase_guard.zsh" # 7DAY_GUARD_HOOK
