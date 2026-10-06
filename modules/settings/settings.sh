CYAN="\033[1;36m"; GREEN="\033[1;32m"; YELLOW="\033[1;33m"; MAGENTA="\033[1;35m"; NC="\033[0m"
#!/usr/bin/env bash

settings_theme() {
    printf 'Theme: SHAHEEN Dark / Silent Sovereign\n'
}

settings_language() {
    printf 'Language: English\n'
}

settings_editor() {
    printf 'Editor: %s\n' "${EDITOR:-auto}"
}

settings_paths() {
    printf 'ROOT : %s\n' "$SHAHEEN_ROOT"
    printf 'DATA : %s\n' "$SHAHEEN_DATA_DIR"
    printf 'LOGS : %s\n' "$SHAHEEN_LOG_DIR"
}

settings_logs() {
    if [ -f "$SHAHEEN_LOG_DIR/shaheen.log" ]; then
        tail -100 "$SHAHEEN_LOG_DIR/shaheen.log"
    else
        printf 'No logs yet.\n'
    fi
}

settings_update() {
    if [ -d "$SHAHEEN_ROOT/.git" ]; then
        git -C "$SHAHEEN_ROOT" pull --ff-only
    else
        warn "SHAHEEN is not a Git working tree."
    fi
}
