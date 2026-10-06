CYAN="\033[1;36m"; GREEN="\033[1;32m"; YELLOW="\033[1;33m"; MAGENTA="\033[1;35m"; NC="\033[0m"
#!/usr/bin/env bash

TARGET="${PREFIX:-$HOME/.local}/bin"

rm -f "$TARGET/shaheen"
rm -f "$TARGET/shaheen"
rm -f "$TARGET/sn"

echo "SHAHEEN command links removed."
