CYAN="\033[1;36m"; GREEN="\033[1;32m"; YELLOW="\033[1;33m"; MAGENTA="\033[1;35m"; NC="\033[0m"
#!/usr/bin/env bash

shaheen_log() {
    mkdir -p "$SHAHEEN_LOG_DIR"
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" \
        >> "$SHAHEEN_LOG_DIR/shaheen.log"
}
