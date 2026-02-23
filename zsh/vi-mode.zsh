
# ── Vi mode ─────────────────────────────────────────────────────────
bindkey -v
export KEYTIMEOUT=1

# Курсоры: beam в INSERT, block в NORMAL
_vi_cursor_beam()  { print -n '\e[5 q' }
_vi_cursor_block() { print -n '\e[1 q' }

# Блоки RPROMPT в стиле powerline
_VI_PROMPT_INSERT="%F{blue}%K{blue}%f%F{black}%K{blue} I %f%k%F{blue}%f"
_VI_PROMPT_NORMAL="%F{red}%K{red}%f%F{black}%K{red} N %f%k%F{red}%f"

function zle-keymap-select {
  case $KEYMAP in
    vicmd)
      RPROMPT="$_VI_PROMPT_NORMAL"
      _vi_cursor_block
      ;;
    viins|main)
      RPROMPT="$_VI_PROMPT_INSERT"
      _vi_cursor_beam
      ;;
  esac
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-init {
  RPROMPT="$_VI_PROMPT_INSERT"
  _vi_cursor_beam
  zle -K viins
  zle reset-prompt
}
zle -N zle-line-init

# Возврат к beam при выходе из zsh
function _vi_cursor_reset { _vi_cursor_beam }
add-zsh-hook zshexit _vi_cursor_reset

# ── Привязки клавиш ──────────────────────────────────────────────────

# Backspace работает корректно после ESC
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char

# Ctrl+W — удалить слово назад в INSERT
bindkey -M viins '^W' backward-kill-word

# Ctrl+A / Ctrl+E в INSERT
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line

# Поиск по истории через Ctrl+R в обоих режимах
bindkey -M viins '^R' history-incremental-search-backward
bindkey -M vicmd '^R' history-incremental-search-backward

# ── История substring search (плагин) ───────────────────────────────
_vi_bind_history_search() {
  if zle -la | grep -q history-substring-search-up; then
    bindkey -M viins '^[[A' history-substring-search-up
    bindkey -M viins '^[[B' history-substring-search-down
    bindkey -M vicmd 'k'    history-substring-search-up
    bindkey -M vicmd 'j'    history-substring-search-down
    add-zsh-hook -d precmd _vi_bind_history_search
  fi
}
add-zsh-hook precmd _vi_bind_history_search

# ── Текстовые объекты (ci", ca(, …) ─────────────────────────────────
autoload -Uz select-bracketed select-quoted
zle -N select-bracketed
zle -N select-quoted

for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
done

# ── Surround (ys, cs, ds) ────────────────────────────────────────────
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd  'cs' change-surround
bindkey -M vicmd  'ds' delete-surround
bindkey -M vicmd  'ys' add-surround
bindkey -M visual 'S'  add-surround
