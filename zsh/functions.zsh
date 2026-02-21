# ~/.config/zsh/functions.zsh

# ── Nautilus в фоне ──────────────────────────────────────────────────
function nhn() {
    nautilus "${1:-.}" & disown
}

# ── Quickshell ───────────────────────────────────────────────────────
function restart-qs() {
    echo "Restarting Quickshell..."
    pkill qs
    sleep 0.5
    nohup qs -p ~/.config/quickshell/ii >/dev/null 2>&1 & disown
}

function qs() {
    if [[ "$1" == "--restart" ]]; then
        restart-qs
    else
        command qs "$@"
    fi
}

# ── Погода ───────────────────────────────────────────────────────────
function weather() {
    local city="${1:-Almaty}"
    curl -s "wttr.in/${city}?lang=ru"
}

# ── Бэкап ────────────────────────────────────────────────────────────
function backup() {
    local backup_dir="$HOME/raf/backups"
    local timestamp=$(date +%Y%m%d_%H%M%S)

    mkdir -p "$backup_dir"

    if [[ $# -eq 0 ]]; then
        local current_dir=$(basename "$(pwd)")
        local backup_name="${backup_dir}/${current_dir}_${timestamp}.tar.gz"
        echo "Создаю бэкап текущей папки..."
        tar -czf "$backup_name" -C .. "$(basename "$(pwd)")"
        echo "Бэкап создан: $backup_name"
        return 0
    fi

    if [[ $# -eq 2 ]]; then
        backup_dir="$2"
        mkdir -p "$backup_dir"
    fi

    local target="$1"

    if [[ -f "$target" ]]; then
        local filename=$(basename "$target")
        local backup_name="${backup_dir}/${filename}_${timestamp}"
        cp "$target" "$backup_name"
        echo "Бэкап файла создан: $backup_name"
    elif [[ -d "$target" ]]; then
        local dirname=$(basename "$target")
        local backup_name="${backup_dir}/${dirname}_${timestamp}.tar.gz"
        tar -czf "$backup_name" -C "$(dirname "$target")" "$(basename "$target")"
        echo "Бэкап папки создан: $backup_name"
    else
        echo "Файл или папка '$target' не найден"
        return 1
    fi
}

# ── QR код ───────────────────────────────────────────────────────────
function qr() {
    if [[ $# -eq 0 ]]; then
        echo "Использование: qr 'текст'"
        return 1
    fi
    curl -s "qr-server.com/api/v1/create-qr-code/?size=200x200&data=$1"
}

# ── Поиск файлов ─────────────────────────────────────────────────────
function findf() {
    if [[ $# -eq 0 ]]; then
        echo "Использование: findf <имя_файла>"
        return 1
    fi
    find . -name "*$1*" -type f
}

# ── База данных ──────────────────────────────────────────────────────
function psql5432() {
    env PGPASSWORD='vdYpYlCsB7YuFp1u' psql \
        -h aws-0-eu-central-1.pooler.supabase.com \
        -p 5432 \
        -d postgres \
        -U postgres.trluujtvwlhjqwyjraij \
        "$@"
}

# ── Копирование вывода команды ────────────────────────────────────────
function ccmd() {
    local TMP="/tmp/kitty_command_output_$(id -u).txt"
    printf '$ %s\n' "$*" > "$TMP"
    local OUTFILE=$(mktemp)
    eval "$@" 2>&1 | tee "$OUTFILE"
    if command -v perl &>/dev/null; then
        perl -pe 's/\x1b\[[0-9;]*[mK]//g' < "$OUTFILE" >> "$TMP"
    else
        sed -r 's/\x1b\[[0-9;]*[mK]//g' < "$OUTFILE" >> "$TMP"
    fi
    rm -f "$OUTFILE"
    if command -v wl-copy &>/dev/null; then
        wl-copy < "$TMP"
    else
        kitty +kitten clipboard < "$TMP" >/dev/null 2>&1
    fi
}
