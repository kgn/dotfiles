#!/bin/bash
# Remove unwanted packages and web apps that come with default Omarchy

set -e

echo "Removing unwanted packages..."

packages=(
    1password-beta
    1password-cli
    libreoffice-fresh
    signal-desktop
    tobi-try
    ruby
)

# Only remove packages that are actually installed
to_remove=()
for pkg in "${packages[@]}"; do
    if pacman -Qi "$pkg" &> /dev/null; then
        to_remove+=("$pkg")
    fi
done

if [ ${#to_remove[@]} -gt 0 ]; then
    echo "Removing: ${to_remove[*]}"
    sudo pacman -Rns --noconfirm "${to_remove[@]}"
else
    echo "No unwanted packages found."
fi

echo ""
echo "Removing unwanted web apps..."

webapps=(
    "HEY"
    "Basecamp"
)

for app in "${webapps[@]}"; do
    desktop_file="$HOME/.local/share/applications/${app}.desktop"
    if [ -f "$desktop_file" ]; then
        echo "Removing $app web app..."
        rm -f "$desktop_file"
    fi
done

echo "Done!"
