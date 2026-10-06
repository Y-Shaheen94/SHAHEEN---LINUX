CYAN="\033[1;36m"; GREEN="\033[1;32m"; YELLOW="\033[1;33m"; MAGENTA="\033[1;35m"; NC="\033[0m"
#!/usr/bin/env bash

crypto_hash() {
    local file="$1"

    [ -f "$file" ] || {
        err "Usage: shaheen crypto hash <file>"
        return 1
    }

    printf 'SHA-256 : '
    sha256sum "$file"

    printf 'SHA-512 : '
    sha512sum "$file"
}

crypto_sha256() {
    sha256sum "$1"
}

crypto_sha512() {
    sha512sum "$1"
}

crypto_checksum() {
    local file="$1"
    [ -f "$file" ] || return 1
    sha256sum "$file"
}

crypto_keygen() {
    local output="${1:-shaheen.key}"

    if command -v openssl >/dev/null 2>&1; then
        openssl rand -hex 32 > "$output"
        chmod 600 "$output"
        ok "Key material generated: $output"
    else
        err "OpenSSL is not installed."
        return 1
    fi
}

crypto_encrypt() {
    local input="$1"
    local output="${2:-$input.enc}"

    [ -f "$input" ] || {
        err "Input file not found."
        return 1
    }

    command -v gpg >/dev/null 2>&1 || {
        err "GPG is not installed."
        return 1
    }

    gpg --symmetric --output "$output" "$input"
    ok "Encrypted: $output"
}

crypto_decrypt() {
    local input="$1"
    local output="${2:-${input%.enc}}"

    [ -f "$input" ] || {
        err "Encrypted file not found."
        return 1
    }

    command -v gpg >/dev/null 2>&1 || {
        err "GPG is not installed."
        return 1
    }

    gpg --output "$output" --decrypt "$input"
    ok "Decrypted: $output"
}

crypto_sign() {
    local file="$1"
    [ -f "$file" ] || return 1
    command -v gpg >/dev/null 2>&1 || return 1
    gpg --armor --detach-sign "$file"
}

crypto_verify() {
    local signature="$1"
    local file="$2"

    command -v gpg >/dev/null 2>&1 || return 1
    gpg --verify "$signature" "$file"
}
