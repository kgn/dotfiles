#!/bin/bash
# Install additional packages not in default Omarchy

set -e

echo "Installing additional packages..."

# Packages from official repos
pacman_packages=(
    nushell
    stow
    pass
    atuin
    protobuf
)

# Packages from AUR (installed via yay)
aur_packages=(
    visual-studio-code-bin
    claude-code
    hyprwhspr
    carapace-bin
)

echo "Syncing package database..."
sudo pacman -Sy

echo "Installing pacman packages..."
sudo pacman -S --noconfirm --needed "${pacman_packages[@]}"

echo "Installing AUR packages..."
yay -S --noconfirm --needed "${aur_packages[@]}"

echo "Installing mise-managed runtimes (go, bun) and Go tools..."
mise install
mise exec -- go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
mise exec -- go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

echo "Installing VS Code extensions..."
code --install-extension enkia.tokyo-night
code --install-extension subframe7536.custom-ui-style
code --install-extension golang.go

# Grant permissions for Custom UI Style extension to modify VS Code
if [ -d "/opt/visual-studio-code/resources/app" ]; then
    echo "Granting permissions for VS Code customization..."
    sudo chown -R "$(whoami)" '/opt/visual-studio-code/resources/app'
fi

echo "Done!"
