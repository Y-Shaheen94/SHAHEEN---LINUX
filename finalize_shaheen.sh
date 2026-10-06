#!/data/data/com.termux/files/usr/bin/bash

set -u

PROJECT="$HOME/shaheen"
BIN="$PROJECT/bin"
CORE="$BIN/shaheen"
PREFIX_SHAHEEN="$PREFIX/bin/shaheen"
PREFIX_SN="$PREFIX/bin/sn"
BACKUP="$BIN/shayeen.backup.modules.20260923_093459"

echo
echo "=============================================="
echo "        SHAHEEN FINAL CONFIGURATION"
echo "=============================================="
echo

# ------------------------------------------------
# 1. Check project
# ------------------------------------------------
if [ ! -d "$PROJECT" ]; then
    echo "[ERROR] Project not found:"
    echo "$PROJECT"
    exit 1
fi

mkdir -p "$BIN"

# ------------------------------------------------
# 2. Detect whether the core is accidentally
#    replaced by the launcher itself
# ------------------------------------------------
IS_WRAPPER=0

if [ -f "$CORE" ]; then
    if grep -qF 'exec "$HOME/shaheen/bin/shaheen" "$@"' "$CORE"; then
        IS_WRAPPER=1
    fi
fi

# ------------------------------------------------
# 3. Restore the real SHAHEEN core if necessary
# ------------------------------------------------
if [ "$IS_WRAPPER" -eq 1 ]; then

    echo "[FIX] The core file is a launcher."
    echo "[FIX] Restoring the real SHAHEEN core..."

    if [ ! -f "$BACKUP" ]; then
        echo
        echo "[ERROR] Backup not found:"
        echo "$BACKUP"
        echo
        exit 2
    fi

    if grep -qF 'exec "$HOME/shaheen/bin/shaheen" "$@"' "$BACKUP"; then
        echo "[ERROR] The backup is also a launcher."
        echo "[ERROR] Aborting to prevent a recursive installation."
        exit 3
    fi

    cp -f "$CORE" "$CORE.before_final_fix" 2>/dev/null || true
    cp -f "$BACKUP" "$CORE"

    echo "[OK] Real SHAHEEN core restored."

else
    echo "[OK] SHAHEEN core is already present."
fi

# ------------------------------------------------
# 4. Make the real core executable
# ------------------------------------------------
chmod +x "$CORE"

# ------------------------------------------------
# 5. Install the shaheen launcher
# ------------------------------------------------
cat > "$PREFIX_SHAHEEN" <<'LAUNCHER'
#!/data/data/com.termux/files/usr/bin/bash
exec "$HOME/shaheen/bin/shaheen" "$@"
LAUNCHER

chmod +x "$PREFIX_SHAHEEN"

# ------------------------------------------------
# 6. Install the sn launcher
# ------------------------------------------------
cat > "$PREFIX_SN" <<'LAUNCHER'
#!/data/data/com.termux/files/usr/bin/bash
exec "$HOME/shaheen/bin/shaheen" "$@"
LAUNCHER

chmod +x "$PREFIX_SN"

# ------------------------------------------------
# 7. Clear command cache
# ------------------------------------------------
hash -r

# ------------------------------------------------
# 8. Validate core
# ------------------------------------------------
echo
echo "------------- VALIDATION ----------------"

if grep -qF 'exec "$HOME/shaheen/bin/shaheen" "$@"' "$CORE"; then
    echo "[ERROR] Core is still a launcher."
    echo "[ERROR] Installation stopped."
    exit 4
fi

echo "[OK] Core file:"
echo "     $CORE"

echo "[OK] shaheen launcher:"
echo "     $PREFIX_SHAHEEN"

echo "[OK] sn launcher:"
echo "     $PREFIX_SN"

# ------------------------------------------------
# 9. Validate command resolution
# ------------------------------------------------
SHAHEEN_PATH="$(command -v shaheen 2>/dev/null || true)"
SN_PATH="$(command -v sn 2>/dev/null || true)"

echo
echo "------------- COMMANDS ------------------"

if [ "$SHAHEEN_PATH" != "$PREFIX_SHAHEEN" ]; then
    echo "[ERROR] shaheen resolves to:"
    echo "$SHAHEEN_PATH"
    exit 5
fi

if [ "$SN_PATH" != "$PREFIX_SN" ]; then
    echo "[ERROR] sn resolves to:"
    echo "$SN_PATH"
    exit 6
fi

echo "[OK] shaheen -> $SHAHEEN_PATH"
echo "[OK] sn      -> $SN_PATH"

# ------------------------------------------------
# 10. Verify launchers
# ------------------------------------------------
echo
echo "------------- LAUNCHERS -----------------"

if ! grep -qF 'exec "$HOME/shaheen/bin/shaheen" "$@"' "$PREFIX_SHAHEEN"; then
    echo "[ERROR] shaheen launcher is invalid."
    exit 7
fi

if ! grep -qF 'exec "$HOME/shaheen/bin/shaheen" "$@"' "$PREFIX_SN"; then
    echo "[ERROR] sn launcher is invalid."
    exit 8
fi

echo "[OK] shaheen launcher valid."
echo "[OK] sn launcher valid."

# ------------------------------------------------
# 11. Final status
# ------------------------------------------------
echo
echo "=============================================="
echo "       SHAHEEN INSTALLATION COMPLETE"
echo "=============================================="
echo
echo "Core:"
echo "  $CORE"
echo
echo "Commands:"
echo "  shaheen"
echo "  sn"
echo
echo "Quick commands:"
echo "  shaheen system info"
echo "  shaheen crypto hash file.txt"
echo "  shaheen download <URL>"
echo "  shaheen dev detect"
echo "  shaheen build"
echo
echo "=============================================="
echo

# ------------------------------------------------
# 12. Launch the final SHAHEEN interface
# ------------------------------------------------
cd "$HOME"
exec "$CORE"
