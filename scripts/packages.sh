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
    kubectl
)

# Packages from AUR (installed via yay)
aur_packages=(
    visual-studio-code-bin
    claude-code
    hyprwhspr
    carapace-bin
    piper-speak
    kind
    buf
)

echo "Syncing package database..."
sudo pacman -Sy

echo "Installing pacman packages..."
sudo pacman -S --noconfirm --needed "${pacman_packages[@]}"

echo "Installing AUR packages..."
yay -S --noconfirm --needed "${aur_packages[@]}"

echo "Done!"
