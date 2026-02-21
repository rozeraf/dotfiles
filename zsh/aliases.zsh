# ~/.config/zsh/aliases.zsh

# ── Entertainment ────────────────────────────────────────────────────
alias matrix='cmatrix'
alias train='sl'
alias hacker='hollywood'
alias fire='aafire'
alias cow='fortune | cowsay | lolcat'

# ── System information ───────────────────────────────────────────────
alias ff='fastfetch --config examples/17.jsonc'
alias now='date +%T'

# ── GUI applications ─────────────────────────────────────────────────
alias pamac='pamac-manager'

# ── Documentation ────────────────────────────────────────────────────
alias githelp='glow ~/githelp.md'
alias aliases='nvim ~/.config/zsh/aliases.zsh'
alias md='glow --tui --line-numbers'

# ── VPS ──────────────────────────────────────────────────────────────
alias deb='ssh -i ~/ssh/ kotyara@2.56.246.105'

# ── Development ──────────────────────────────────────────────────────
alias aiset='~/scripts/set_model.sh'

# ── Config editors ───────────────────────────────────────────────────
alias hypr='nvim ~/.config/hypr/hyprland.conf'
alias bashrc='nvim ~/.bashrc'
alias zshrc='nvim ~/.zshrc'
alias fishrc='nvim ~/.config/fish/config.fish'
alias nsddm='nvim /etc/sddm.conf'
alias pconf='nvim /etc/pacman.conf'
alias mkpkg='nvim /etc/makepkg.conf'
alias ngrub='nvim /etc/default/grub'
alias smbconf='nvim /etc/samba/smb.conf'
alias nmirrorlist='nvim /etc/pacman.d/mirrorlist'

# ── Help ─────────────────────────────────────────────────────────────
alias zshhelp='~/scripts/fishhelp.sh'

# ── Torrent ──────────────────────────────────────────────────────────
alias qbt='qbittorrent'

# ── File tools ───────────────────────────────────────────────────────
alias fnvim='fzf --preview "bat --color=always {}" | xargs nvim'
alias tree='eza --tree --icons --git-ignore'
alias tree2='eza --tree --icons --level=2'
alias tree3='eza --tree --icons --level=3'
alias ls='eza --icons'
alias ll='eza -la --icons'
alias lt='eza --tree --icons'
alias cat='bat'
alias grep='rg'
alias find='fd'

# ── Navigation ───────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ── Git ──────────────────────────────────────────────────────────────
alias gps='git push'
alias gpl='git pull'
alias gst='git status'
alias glo='git log --oneline'
alias gac='python /home/raf/git/users/rozeraf/python/autocommit/main.py'

# ── Misc ─────────────────────────────────────────────────────────────
alias oops='sudo $(history | tail -1 | cut -c 8-)'
alias please='sudo $(history | tail -1 | cut -c 8-)'
alias path='echo $PATH | tr : "\n"'
alias apple='cd Видео/ && tplay videoplayback.mp4'
alias obsid='nohup obsidian --disable-gpu > ~/obsidian.log 2>&1 & disown'
alias curconv='~/git/users/rozeraf/bash/currency-converter/currency_converter.sh'
alias nvimtutormd='glow ~/.config/nvimtutor.md --tui'
alias clear="printf '\033[2J\033[3J\033[1;1H'"
alias q='qs -c ii'
alias sduo='sudo'
alias pamcan='pacman'

# ── Package management ───────────────────────────────────────────────
alias search='sudo pacman -Qs'
alias check='sudo pacman -Q'
alias remove='sudo pacman -R'
alias i='sudo pacman -S --needed'
alias linstall='sudo pacman -U'
alias update='sudo pacman -Syyu'
alias clrcache='sudo pacman -Scc'
alias updb='paru && sudo pacman -Sy'
alias orphans='sudo pacman -Rns $(pacman -Qtdq)'
alias sybau='sudo pacman -Syu'
alias pget='paru -S'
alias prm='paru -Rs'
alias psr='paru -Ss'
alias pupdate='paru -Syyu --noconfirm'
