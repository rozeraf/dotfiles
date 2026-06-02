# ── zinit ────────────────────────────────────────────────────────────
source /usr/share/zinit/zinit.zsh

# ── Плагины (lazy loading — грузятся после появления prompt'а) ───────
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light Aloxaf/fzf-tab

zinit ice wait lucid
zinit light zsh-users/zsh-history-substring-search

zinit ice wait lucid
zinit light MichaelAquilina/zsh-you-should-use

# omzsh-плагины которые стоит сохранить
# copypath в pwdcopy в ~/.config/zsh/functions.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/git/git.plugin.zsh

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

# ── Базовые настройки ────────────────────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim

# ── История ──────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

# ── Fastfetch ──────────────────────────────────────────────────────────
fastfetch

# ── Автодополнение ───────────────────────────────────────────────────
autoload -Uz compinit
# обновляет кэш раз в сутки, иначе использует кэш
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# ── PATH ─────────────────────────────────────────────────────────────
typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$HOME/.bun/bin"
  $path
)
export PATH

# ── Сторонние инициализации ──────────────────────────────────────────
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
# zx -> zoxide query -i alias in ~/.config/zsh/aliases.zsh

# thefuck — lazy: запускается только при первом вызове fuck
# fuck() {
#   eval "$(thefuck --alias)"
#   fuck "$@"
# }

if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# ── Angular CLI (если нужен) ─────────────────────────────────────────
# предварительно сгенерировать: ng completion script > ~/.config/zsh/ng-completion.zsh
# [[ -f ~/.config/zsh/ng-completion.zsh ]] && source ~/.config/zsh/ng-completion.zsh

# ── Quickshell sequences ─────────────────────────────────────────────
# [[ -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt ]] && \
#   cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt

# ── Модули ───────────────────────────────────────────────────────────
[[ -f ~/.config/zsh/aliases.zsh   ]] && source ~/.config/zsh/aliases.zsh
[[ -f ~/.config/zsh/functions.zsh ]] && source ~/.config/zsh/functions.zsh
[[ -f ~/.config/zsh/network.zsh   ]] && source ~/.config/zsh/network.zsh
[[ -f ~/.config/zsh/vi-mode.zsh ]] && source ~/.config/zsh/vi-mode.zsh

# ── fzf ──────────────────────────────────────────────────────────────
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
export FZF_DEFAULT_OPTS="
  --border=rounded
  --padding=0,1
  --margin=1,2
  --height=40%
  --layout=reverse
  --info=inline
  --color=border:#89b4fa,bg+:#313244,fg+:#cdd6f4,hl:#f38ba8,hl+:#f38ba8,prompt:#89b4fa,pointer:#f5c2e7,marker:#a6e3a1,spinner:#f5c2e7,header:#89b4fa
"

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -la --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --border=rounded --padding=0,1

# bun completions
[ -s "/home/raf/.bun/_bun" ] && source "/home/raf/.bun/_bun"


# Added by Antigravity CLI installer
export PATH="/home/raf/.local/bin:$PATH"
