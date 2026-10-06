CYAN="\033[1;36m"; GREEN="\033[1;32m"; YELLOW="\033[1;33m"; MAGENTA="\033[1;35m"; NC="\033[0m"
#!/data/data/com.termux/files/usr/bin/bash

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="$PREFIX/bin/shaheen"

echo "Installing SHΛHEEN Toolkit..."

chmod +x "$PROJECT_DIR/bin/shaheen"

ln -sf "$PROJECT_DIR/bin/shaheen" "$TARGET"

echo
echo "SHΛHEEN Toolkit installed."
echo
echo "Run:"
echo "  shaheen"
echo
