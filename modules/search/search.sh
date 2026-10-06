CYAN="\033[1;36m"; GREEN="\033[1;32m"; YELLOW="\033[1;33m"; MAGENTA="\033[1;35m"; NC="\033[0m"
#!/usr/bin/env bash

search_files() {
    files_search "$@"
}

search_text() {
    local pattern="$1"
    local path="${2:-$HOME}"

    [ -n "$pattern" ] || return 1

    grep -RIn \
        --exclude-dir=.git \
        --exclude-dir=node_modules \
        --exclude-dir=.gradle \
        -- "$pattern" "$path" 2>/dev/null | head -300
}
