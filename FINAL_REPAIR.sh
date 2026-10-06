#!/data/data/com.termux/files/usr/bin/bash

set -e

PROJECT="$HOME/shaheen"
CORE="$PROJECT/bin/shaheen"
BACKUP="$PROJECT/bin/shayeen.backup.modules.20260923_093459"

echo
echo "=============================================="
echo "        SHAHEEN FINAL REPAIR v2"
echo "=============================================="
echo

# 1. Verify real backup
if [ ! -f "$BACKUP" ]; then
    echo "[ERROR] Backup not found:"
    echo "$BACKUP"
    exit 1
fi

BACKUP_SIZE=$(wc -c < "$BACKUP")

if [ "$BACKUP_SIZE" -lt 1000 ]; then
    echo "[ERROR] Backup is unexpectedly small."
    exit 2
fi

if grep -qF 'exec "$HOME/shaheen/bin/shaheen" "$@"' "$BACKUP"; then
    echo "[ERROR] Backup is also a recursive launcher."
    exit 3
fi

echo "[OK] Real backup verified."
echo "[OK] Backup size: $BACKUP_SIZE bytes"

# 2. Preserve current broken file
if [ -f "$CORE" ]; then
    cp -f "$CORE" "$PROJECT/bin/shaheen.wrapper.removed"
    echo "[OK] Old 81-byte wrapper preserved as:"
    echo "     $PROJECT/bin/shaheen.wrapper.removed"
fi

# 3. Restore REAL program
cp -f "$BACKUP" "$CORE"
chmod 700 "$CORE"

# 4. Verify restoration
CORE_SIZE=$(wc -c < "$CORE")

if [ "$CORE_SIZE" -ne "$BACKUP_SIZE" ]; then
    echo "[ERROR] Core size does not match backup."
    exit 4
fi

if grep -qF 'exec "$HOME/shaheen/bin/shaheen" "$@"' "$CORE"; then
    echo "[ERROR] Core is still a wrapper."
    exit 5
fi

echo "[OK] Real SHAHEEN core restored."
echo "[OK] Core size: $CORE_SIZE bytes"

# 5. Remove the two existing symbolic links
rm -f "$PREFIX/bin/shaheen"
rm -f "$PREFIX/bin/sn"

# 6. Create REAL launchers
cat > "$PREFIX/bin/shaheen" <<'LAUNCHER'
#!/data/data/com.termux/files/usr/bin/bash
exec "$HOME/shaheen/bin/shaheen" "$@"
LAUNCHER

cat > "$PREFIX/bin/sn" <<'LAUNCHER'
#!/data/data/com.termux/files/usr/bin/bash
exec "$HOME/shaheen/bin/shaheen" "$@"
LAUNCHER

chmod 700 "$PREFIX/bin/shaheen" "$PREFIX/bin/sn"

# 7. Clear command hash
hash -r

# 8. Verify they are regular files, not symlinks
if [ -L "$PREFIX/bin/shaheen" ]; then
    echo "[ERROR] shaheen is still a symbolic link."
    exit 6
fi

if [ -L "$PREFIX/bin/sn" ]; then
    echo "[ERROR] sn is still a symbolic link."
    exit 7
fi

echo "[OK] shaheen launcher is a regular file."
echo "[OK] sn launcher is a regular file."

# 9. Verify paths
echo
echo "------------- FINAL PATHS ----------------"

echo "shaheen: $(command -v shaheen)"
echo "sn:      $(command -v sn)"

echo
echo "------------- FINAL SIZES ----------------"

ls -lh "$CORE"
ls -lh "$PREFIX/bin/shaheen"
ls -lh "$PREFIX/bin/sn"

echo
echo "=============================================="
echo "        REPAIR COMPLETE"
echo "=============================================="
echo

# 10. Launch REAL CORE directly
cd "$HOME"
exec "$CORE"
