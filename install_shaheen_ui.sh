#!/data/data/com.termux/files/usr/bin/bash

UI="$HOME/shaheen/core/ui.sh"

cp "$UI" "$UI.bak.$(date +%s)"

cat >> "$UI" <<'EOC'

animate_shaheen() {
    local name="SHAHEEN"

    printf "\r${BRIGHT_MAGENTA}⟦SN-🜏⟧ ${RESET}"

    for ((i=1;i<=${#name};i++)); do
        printf "\r${BRIGHT_MAGENTA}⟦SN-🜏⟧ ${BRIGHT_CYAN}%s${RESET}" \
            "${name:0:i}"
        sleep 0.06
    done

    printf "\r${BRIGHT_MAGENTA}⟦SN-🜏⟧ ${BRIGHT_GREEN}READY${RESET}\n"
}

status_install() {
    printf "${BRIGHT_BLUE}[INSTALL]${RESET} %s\n" "$1"
}

status_ok() {
    printf "${BRIGHT_GREEN}[SUCCESS]${RESET} %s\n" "$1"
}

status_error() {
    printf "${BRIGHT_RED}[ERROR]${RESET} %s\n" "$1"
}

status_warn() {
    printf "${BRIGHT_YELLOW}[WARNING]${RESET} %s\n" "$1"
}
EOC

mkdir -p "$PREFIX/bin"

cat > "$PREFIX/bin/shaheen" <<'LAUNCH'
#!/data/data/com.termux/files/usr/bin/bash
cd "$HOME/shaheen" || exit 1
exec bash "$HOME/shaheen/bin/shaheen" "$@"
LAUNCH

chmod +x "$PREFIX/bin/shaheen"

cat > "$PREFIX/bin/sn" <<'LAUNCH'
#!/data/data/com.termux/files/usr/bin/bash
cd "$HOME/shaheen" || exit 1
exec bash "$HOME/shaheen/bin/shaheen" "$@"
LAUNCH

chmod +x "$PREFIX/bin/sn"

echo "[OK] SHAHEEN launcher installed"
