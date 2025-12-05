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
    piper-tts-bin
)

echo "Syncing package database..."
sudo pacman -Sy

echo "Installing pacman packages..."
sudo pacman -S --noconfirm --needed "${pacman_packages[@]}"

echo "Installing AUR packages..."
yay -S --noconfirm --needed "${aur_packages[@]}"

echo "Installing hyprwhspr fork with push-to-talk and key grabbing..."
HYPRWHSPR_FORK="$HOME/Development/hyprwhspr"
if [ ! -d "$HYPRWHSPR_FORK" ]; then
    git clone https://github.com/kgn/hyprwhspr.git "$HYPRWHSPR_FORK"
else
    git -C "$HYPRWHSPR_FORK" pull
fi
sudo cp "$HYPRWHSPR_FORK/lib/src/global_shortcuts.py" /usr/lib/hyprwhspr/lib/src/
sudo cp "$HYPRWHSPR_FORK/lib/main.py" /usr/lib/hyprwhspr/lib/

echo "Installing mise-managed runtimes (go, bun) and Go tools..."
mise install
mise exec -- go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
mise exec -- go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

echo "Setting up Piper TTS voice..."
PIPER_VOICE_DIR="$HOME/.local/share/piper/voices"
PIPER_VOICE="en_US-lessac-medium"
if [ ! -f "$PIPER_VOICE_DIR/$PIPER_VOICE.onnx" ]; then
    mkdir -p "$PIPER_VOICE_DIR"
    echo "  Downloading $PIPER_VOICE voice model..."
    curl -L "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx" \
        -o "$PIPER_VOICE_DIR/$PIPER_VOICE.onnx"
    curl -L "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx.json" \
        -o "$PIPER_VOICE_DIR/$PIPER_VOICE.onnx.json"
else
    echo "  Piper voice already installed"
fi

echo "Installing VS Code extensions..."
code --install-extension enkia.tokyo-night
code --install-extension subframe7536.custom-ui-style
code --install-extension golang.go
code --install-extension ms-python.python
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode

# Grant permissions for Custom UI Style extension to modify VS Code
if [ -d "/opt/visual-studio-code/resources/app" ]; then
    echo "Granting permissions for VS Code customization..."
    sudo chown -R "$(whoami)" '/opt/visual-studio-code/resources/app'
fi

echo "Done!"
