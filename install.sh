#!/bin/bash
# Dotfiles installer
# Usage: ./install.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Installing dotfiles ==="

# Step 1: Install additional packages
echo ""
echo "Step 1: Installing packages..."
"$DOTFILES_DIR/scripts/packages.sh"

# Step 2: Remove unwanted packages
echo ""
echo "Step 2: Cleaning up unwanted packages..."
"$DOTFILES_DIR/scripts/cleanup.sh"

# Step 3: Stow config files
echo ""
echo "Step 3: Stowing config files..."
cd "$DOTFILES_DIR"

packages=(bash nushell starship hyprwhspr hypr)

for package in "${packages[@]}"; do
    if [ -d "$package" ]; then
        echo "  Stowing $package..."
        stow -v --target="$HOME" "$package"
    fi
done

# Step 4: Setup hyprwhspr (first-time setup)
if command -v hyprwhspr-setup &> /dev/null; then
    echo ""
    echo "Step 4: Run 'hyprwhspr-setup' to complete speech-to-text setup"
fi

echo ""
echo "=== Done! Log out and back in for changes to take effect ==="
