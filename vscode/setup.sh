#!/bin/bash
# VS Code setup - extensions and permissions

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Installing VS Code extensions..."
code --install-extension enkia.tokyo-night
code --install-extension subframe7536.custom-ui-style
code --install-extension golang.go
code --install-extension ms-python.python
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension ms-azuretools.vscode-docker

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
