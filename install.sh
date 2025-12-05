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

packages=(bash nushell starship hyprwhspr vscode mise bin)

for package in "${packages[@]}"; do
    if [ -d "$package" ]; then
        echo "  Stowing $package..."
        # First unstow to clean up any existing links
        stow -D --target="$HOME" "$package" 2>/dev/null || true
        # Then stow fresh (without --adopt to avoid overwriting dotfiles)
        stow -v --target="$HOME" "$package"
    fi
done

# Hypr configs need individual symlinks (directory has other non-managed files)
echo "  Linking hypr configs..."
for file in "$DOTFILES_DIR"/hypr/.config/hypr/*.conf; do
    filename=$(basename "$file")
    target="$HOME/.config/hypr/$filename"
    rm -f "$target"
    ln -sv "$file" "$target"
done

# VS Code extensions (copy to avoid conflicts with existing extensions dir)
echo "  Installing VS Code extensions from dotfiles..."
if [ -d "$DOTFILES_DIR/vscode/extensions" ]; then
    cp -r "$DOTFILES_DIR/vscode/extensions"/* "$HOME/.vscode/extensions/"
fi

# Step 4: Set nushell as default shell
if command -v nu &> /dev/null; then
    current_shell=$(getent passwd "$USER" | cut -d: -f7)
    if [ "$current_shell" != "/usr/bin/nu" ]; then
        echo ""
        echo "Step 4: Setting nushell as default shell..."
        sudo chsh -s /usr/bin/nu "$USER"
    fi
fi

# Step 5: Setup hyprwhspr (first-time setup)
if command -v hyprwhspr-setup &> /dev/null; then
    echo ""
    echo "Step 5: Setting up hyprwhspr (speech-to-text)..."
    hyprwhspr-setup
fi

echo ""
echo "=== Done! Log out and back in for changes to take effect ==="
