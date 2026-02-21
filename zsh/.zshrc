# ~/.zshrc

# ── Oh My Zsh ────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

plugins=(
    git
    node
    npm
    you-should-use
    vscode
    docker
    zsh-autosuggestions
    fzf-tab
    zsh-syntax-highlighting
    sudo        # двойной Esc добавляет sudo к предыдущей команде
    dirhistory  # Alt+Left/Right — навигация по истории директорий
    copypath    # копирует текущий путь в буфер
    jsontools   # pp_json и другие json утилиты
    history-substring-search
    command-not-found
)

source $ZSH/oh-my-zsh.sh

# ── Базовые настройки ────────────────────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim

# ── История ──────────────────────────────────────────────────────────
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# ── PATH ─────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
export PATH="$HOME/.pyenv/bin:$PATH"

# ── bun ──────────────────────────────────────────────────────────────
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# ── pyenv ────────────────────────────────────────────────────────────
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# ── Сторонние инициализации ──────────────────────────────────────────
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

if command -v thefuck &>/dev/null; then
    eval "$(thefuck --alias)"
fi

if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi

# ── Angular CLI ──────────────────────────────────────────────────────
[[ -f "$(command -v ng 2>/dev/null)" ]] && source <(ng completion script)

# ── Quickshell sequences ─────────────────────────────────────────────
[[ -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt ]] && \
    cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt

# ── Модули ───────────────────────────────────────────────────────────
[[ -f ~/.config/zsh/aliases.zsh   ]] && source ~/.config/zsh/aliases.zsh
[[ -f ~/.config/zsh/functions.zsh ]] && source ~/.config/zsh/functions.zsh
[[ -f ~/.config/zsh/network.zsh   ]] && source ~/.config/zsh/network.zsh

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

# стиль превью в fzf-tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --border=rounded --padding=0,1
