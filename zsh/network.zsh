# ~/.config/zsh/network.zsh

# ── Порты ────────────────────────────────────────────────────────────
function ports() {
    if [[ -n "$1" ]]; then
        lsof -i ":$1"
    else
        lsof -i -P -n | rg LISTEN
    fi
}

# ── Убить процесс на порту ────────────────────────────────────────────
function killport() {
    if [[ $# -eq 0 ]]; then
        echo "Использование: killport <номер_порта>"
        return 1
    fi
    local pid=$(lsof -ti ":$1")
    if [[ -n "$pid" ]]; then
        kill -9 "$pid"
        echo "Процесс на порту $1 (PID: $pid) завершён"
    else
        echo "Не найден процесс на порту $1"
    fi
}

# ── IP адреса ────────────────────────────────────────────────────────
function myip() {
    echo "Внешний IP:"
    curl -s ifconfig.me
    echo ""
    echo "Локальный IP:"
    ifconfig | rg "inet " | rg -v 127.0.0.1 | awk '{print $2}'
}
