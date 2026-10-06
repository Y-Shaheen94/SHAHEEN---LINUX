CYAN="\033[1;36m"; GREEN="\033[1;32m"; YELLOW="\033[1;33m"; MAGENTA="\033[1;35m"; NC="\033[0m"
#!/usr/bin/env bash

download_file() {
    local url="$1"
    [ -n "$url" ] || {
        err "Usage: shaheen download <URL>"
        return 1
    }

    command -v curl >/dev/null 2>&1 || {
        err "curl is not installed."
        return 1
    }

    curl -fL --progress-bar --remote-name "$url"
}

download_url() {
    download_file "$1"
}

download_checksum() {
    local file="$1"
    [ -f "$file" ] || return 1
    sha256sum "$file"
}

download_resume() {
    local url="$1"
    [ -n "$url" ] || return 1
    curl -fL -C - --progress-bar --remote-name "$url"
}

download_extract() {
    local archive="$1"
    local destination="${2:-.}"

    [ -f "$archive" ] || {
        err "Archive not found."
        return 1
    }

    mkdir -p "$destination"

    case "$archive" in
        *.tar.gz|*.tgz) tar -xzf "$archive" -C "$destination" ;;
        *.tar.xz) tar -xJf "$archive" -C "$destination" ;;
        *.tar.bz2) tar -xjf "$archive" -C "$destination" ;;
        *.tar) tar -xf "$archive" -C "$destination" ;;
        *.zip) unzip -o "$archive" -d "$destination" ;;
        *) err "Unsupported archive format."; return 1 ;;
    esac
}
