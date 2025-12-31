#!/bin/bash
# Dotfiles installer - auto-detects platform
# Usage: ./install.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname)" in
    Darwin)
        exec "$DOTFILES_DIR/install-macos.sh"
        ;;
    Linux)
        exec "$DOTFILES_DIR/install-linux.sh"
        ;;
    *)
        echo "Unsupported platform: $(uname)"
        exit 1
        ;;
esac
