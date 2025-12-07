#!/bin/bash
# Setup Docker daemon config with registry mirror
#
# Creates a symlink from /etc/docker/daemon.json to this config.
# Requires sudo and a Docker restart to take effect.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/daemon.json"
TARGET="/etc/docker/daemon.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: daemon.json not found"
    exit 1
fi

# Check if already linked
if [ -L "$TARGET" ] && [ "$(readlink -f "$TARGET")" = "$CONFIG_FILE" ]; then
    echo "Docker daemon.json already linked"
    exit 0
fi

echo "Setting up Docker daemon config..."

# Backup existing config if it exists and is not a symlink
if [ -f "$TARGET" ] && [ ! -L "$TARGET" ]; then
    echo "  Backing up existing $TARGET to ${TARGET}.bak"
    sudo mv "$TARGET" "${TARGET}.bak"
fi

# Create symlink
sudo mkdir -p /etc/docker
sudo ln -sf "$CONFIG_FILE" "$TARGET"
echo "  Linked $TARGET -> $CONFIG_FILE"

echo ""
echo "Docker config installed. Restart Docker to apply:"
echo "  sudo systemctl restart docker"
