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

# Step 2: Setup mise runtimes
echo ""
echo "Step 2: Setting up mise..."
"$DOTFILES_DIR/mise/setup.sh"

# Step 2a: Setup Claude Code MCP servers
echo ""
echo "Step 2a: Setting up Claude Code MCP servers..."
"$DOTFILES_DIR/claude/setup-mcp.sh"

# Step 3: Remove unwanted packages
echo ""
echo "Step 3: Cleaning up unwanted packages..."
"$DOTFILES_DIR/scripts/cleanup.sh"

# Step 4: Stow config files
echo ""
echo "Step 4: Stowing config files..."
cd "$DOTFILES_DIR"

packages=(bash nushell starship hyprwhspr vscode mise bin claude waybar)

for package in "${packages[@]}"; do
    if [ -d "$package" ]; then
        echo "  Stowing $package..."
        # First unstow to clean up any existing links
        stow -D --target="$HOME" "$package" 2>/dev/null || true
        # Remove any existing non-symlink files that would conflict with stow
        while IFS= read -r target; do
            target="$HOME/$target"
            if [ -e "$target" ] && [ ! -L "$target" ]; then
                echo "    Removing conflicting file: $target"
                rm -f "$target"
            fi
        done < <(cd "$DOTFILES_DIR/$package" && find . -type f ! -name 'setup.sh' | sed 's|^\./||')
        # Then stow fresh (ignore setup.sh scripts which are run separately)
        stow -v --ignore='setup\.sh' --target="$HOME" "$package"
    fi
done

# Hypr configs need individual symlinks (directory has other non-managed files)
# Remove all first, then create all, to avoid partial state during hyprland auto-reload
echo "  Linking hypr configs..."
for file in "$DOTFILES_DIR"/hypr/.config/hypr/*.conf; do
    rm -f "$HOME/.config/hypr/$(basename "$file")"
done
for file in "$DOTFILES_DIR"/hypr/.config/hypr/*.conf; do
    ln -sv "$file" "$HOME/.config/hypr/$(basename "$file")"
done
hyprctl reload 2>/dev/null || true

# Step 5: Setup VS Code
echo ""
echo "Step 5: Setting up VS Code..."
"$DOTFILES_DIR/vscode/setup.sh"

# Step 6: Setup Docker daemon config
echo ""
echo "Step 6: Setting up Docker..."
"$DOTFILES_DIR/docker/setup.sh"

# Step 7: Set nushell as default shell
if command -v nu &> /dev/null; then
    current_shell=$(getent passwd "$USER" | cut -d: -f7)
    if [ "$current_shell" != "/usr/bin/nu" ]; then
        echo ""
        echo "Step 7: Setting nushell as default shell..."
        sudo chsh -s /usr/bin/nu "$USER"
    fi
fi

echo ""
echo "=== Done! Log out and back in for changes to take effect ==="
