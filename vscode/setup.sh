#!/bin/bash
# VS Code setup - extensions and permissions

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Use clean environment to avoid mise Node conflicts with VS Code's bundled Node
install_ext() {
    env -i HOME="$HOME" PATH="/usr/local/bin:/usr/bin:/bin" code --install-extension "$1" || true
}

echo "Installing VS Code extensions..."
install_ext enkia.tokyo-night
install_ext subframe7536.custom-ui-style
install_ext golang.go
install_ext ms-python.python
install_ext dbaeumer.vscode-eslint
install_ext esbenp.prettier-vscode
install_ext ms-azuretools.vscode-docker

# Grant permissions for Custom UI Style extension to modify VS Code
if [ -d "/opt/visual-studio-code/resources/app" ]; then
    echo "Granting permissions for VS Code customization..."
    sudo chown -R "$(whoami)" '/opt/visual-studio-code/resources/app'
fi

# Copy custom extensions
if [ -d "$DOTFILES_DIR/vscode/extensions" ]; then
    echo "Installing custom VS Code extensions from dotfiles..."
    cp -r "$DOTFILES_DIR/vscode/extensions"/* "$HOME/.vscode/extensions/"
fi
