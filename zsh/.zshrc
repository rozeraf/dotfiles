# zshrc

# Environment

export EDITOR=nvim
export VISUAL=nvim

typeset -U path PATH

path=(
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.bun/bin"
    $path
)


# Shell

# Vi mode
bindkey -v

vi-paste-clipboard() {
    local old_cutbuffer="$CUTBUFFER"

    CUTBUFFER="$(wl-paste --no-newline 2>/dev/null)" || return

    zle vi-put-after

    CUTBUFFER="$old_cutbuffer"
}

zle -N vi-paste-clipboard
bindkey -M vicmd 'p' vi-paste-clipboard

KEYTIMEOUT=5

unsetopt BEEP

# History

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS


# Completion

autoload -Uz compinit

# Use cached completion dump when possible.
if [[ -n "$HOME/.zcompdump"(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}'

zstyle ':completion:*' menu no


# Plugins (hate inits overhead)

# Autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# History substring search
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# fzf-tab
source "$HOME/.local/share/zsh/fzf-tab/fzf-tab.plugin.zsh"


# Autosuggestions

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#585b70'


# History search

bindkey -M viins '^[[A' history-substring-search-up
bindkey -M viins '^[[B' history-substring-search-down

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down


# fzf

[[ -f /usr/share/fzf/key-bindings.zsh ]] && \
    source /usr/share/fzf/key-bindings.zsh

[[ -f /usr/share/fzf/completion.zsh ]] && \
    source /usr/share/fzf/completion.zsh

export FZF_DEFAULT_OPTS='
    --height=80%
    --layout=reverse
    --border=rounded
    --padding=0,1
    --margin=1,2
    --info=inline
    --color=border:#cba6f7
    --color=bg+:#313244
    --color=fg+:#cdd6f4
    --color=hl:#cba6f7
    --color=hl+:#cba6f7
    --color=prompt:#cba6f7
    --color=pointer:#f5c2e7
    --color=marker:#a6e3a1
'
zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:*' fzf-flags \
    --border=rounded \
    --padding=0,1

# Preview directory contents with my own elx
zstyle ':fzf-tab:complete:cd:*' \
    fzf-preview 'elx -l -a --no-hyperlinks "$realpath"'

# Bun

[[ -s "$HOME/.bun/_bun" ]] && \
    source "$HOME/.bun/_bun"


# Personal config

[[ -f "$HOME/.config/zsh/aliases.zsh" ]] && \
    source "$HOME/.config/zsh/aliases.zsh"

[[ -f "$HOME/.config/zsh/functions.zsh" ]] && \
    source "$HOME/.config/zsh/functions.zsh"


# Zoxide

eval "$(zoxide init zsh)"


# Prompt

eval "$(starship init zsh)"


# ------------------------------------------------------------
# Syntax highlighting
#
# Keep this at the END of .zshrc.
# ------------------------------------------------------------

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
