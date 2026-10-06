#!/data/data/com.termux/files/usr/bin/bash

PROJECT="$HOME/shaheen"
CORE="$PROJECT/bin/shaheen"
BACKUP="$PROJECT/bin/shayeen.backup.modules.20260923_093459"

echo
echo "=============================================="
echo "       SHAHEEN FINAL REPAIR"
echo "=============================================="
echo

# ------------------------------------------------
# 1. Verify backup exists
# ------------------------------------------------

if [ ! -f "$BACKUP" ]; then
    echo "[ERROR] Backup file not found:"
    echo "$BACKUP"
    exit 1
fi

echo "[OK] Backup found:"
echo "$BACKUP"

# ------------------------------------------------
# 2. Verify backup is NOT the recursive launcher
# ------------------------------------------------

if grep -qF 'exec "$HOME/shaheen/bin/shaheen" "$@"' "$BACKUP"; then
    echo
    echo "[ERROR] The backup itself is a launcher."
    echo "[ERROR] Repair aborted."
    exit 2
fi

echo "[OK] Backup contains the real SHAHEEN program."

# ------------------------------------------------
# 3. Backup the currently broken core
# ------------------------------------------------

if [ -f "$CORE" ]; then
    cp -f "$CORE" "$PROJECT/bin/shaheen.broken.before_final_fix"
    echo "[OK] Broken core preserved."
fi

# ------------------------------------------------
# 4. Restore the real core
# ------------------------------------------------

cp -f "$BACKUP" "$CORE"
chmod +x "$CORE"

echo "[OK] Real SHAHEEN core restored."

# ------------------------------------------------
# 5. Verify restored core
# ------------------------------------------------

if grep -qF 'exec "$HOME/shaheen/bin/shaheen" "$@"' "$CORE"; then
    echo
    echo "[ERROR] Restoration failed."
    echo "[ERROR] Core is still a launcher."
    exit 3
fi

echo "[OK] Core verification passed."

# ------------------------------------------------
# 6. Create shaheen launcher
# ------------------------------------------------

cat > "$PREFIX/bin/shaheen" <<'LAUNCHER'
#!/data/data/com.termux/files/usr/bin/bash
exec "$HOME/shaheen/bin/shaheen" "$@"
LAUNCHER

chmod +x "$PREFIX/bin/shaheen"

# ------------------------------------------------
# 7. Create sn launcher
# ------------------------------------------------

cat > "$PREFIX/bin/sn" <<'LAUNCHER'
#!/data/data/com.termux/files/usr/bin/bash
exec "$HOME/shaheen/bin/shaheen" "$@"
LAUNCHER

chmod +x "$PREFIX/bin/sn"

# ------------------------------------------------
# 8. Clear command cache
# ------------------------------------------------

hash -r

# ------------------------------------------------
# 9. Verify command paths
# ------------------------------------------------

echo
echo "------------- COMMAND PATHS ----------------"

echo "shaheen: $(command -v shaheen)"
echo "sn:      $(command -v sn)"

# ------------------------------------------------
# 10. Verify launchers
# ------------------------------------------------

if ! grep -qF 'exec "$HOME/shaheen/bin/shaheen" "$@"' "$PREFIX/bin/shaheen"; then
    echo "[ERROR] shaheen launcher verification failed."
    exit 4
fi

if ! grep -qF 'exec "$HOME/shaheen/bin/shaheen" "$@"' "$PREFIX/bin/sn"; then
    echo "[ERROR] sn launcher verification failed."
    exit 5
fi

echo "[OK] shaheen launcher verified."
echo "[OK] sn launcher verified."

# ------------------------------------------------
# 11. Final status
# ------------------------------------------------

echo
echo "=============================================="
echo "       SHAHEEN REPAIR COMPLETED"
echo "=============================================="
echo
echo "Real core:"
echo "$CORE"
echo
echo "shaheen:"
echo "$PREFIX/bin/shaheen"
echo
echo "sn:"
echo "$PREFIX/bin/sn"
echo
echo "=============================================="
echo

# ------------------------------------------------
# 12. Start SHAHEEN from HOME
# ------------------------------------------------

cd "$HOME"
exec "$CORE"
