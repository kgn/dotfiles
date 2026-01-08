#!/bin/bash
# macOS Dotfiles installer
# Usage: ./install-macos.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Installing dotfiles (macOS) ==="

# Step 1: Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo ""
    echo "Step 1: Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo ""
    echo "Step 1: Homebrew already installed"
fi

# Step 2: Install packages
echo ""
echo "Step 2: Installing packages..."
brew install stow mise starship protobuf bufbuild/buf/buf kind istioctl

# Shell and tools
brew install nushell atuin zoxide

# TTS for Claude Code hooks (piper via pip)
pip3 install piper-tts
# Symlink piper to /usr/local/bin (pip installs to user site-packages bin)
PIPER_BIN=$(python3 -m site --user-base)/bin/piper
if [ -f "$PIPER_BIN" ]; then
    sudo ln -sf "$PIPER_BIN" /usr/local/bin/piper
fi

# Install casks (skip if already installed)
brew install --cask visual-studio-code 2>/dev/null || true
brew install --cask ghostty 2>/dev/null || true

# Claude Code via npm (or brew if available)
if ! command -v claude &> /dev/null; then
    echo "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code 2>/dev/null || echo "Note: Install Claude Code manually if npm not available"
fi

# Step 3: Stow cross-platform configs
echo ""
echo "Step 3: Stowing config files..."
cd "$DOTFILES_DIR"

# These packages use ~/.config/ which works on macOS
packages=(claude mise starship nushell)

for package in "${packages[@]}"; do
    if [ -d "$package" ]; then
        echo "  Stowing $package..."
        stow -D --target="$HOME" "$package" 2>/dev/null || true
        stow -v --ignore='setup\.sh' --target="$HOME" "$package"
    fi
done

# Nushell uses ~/Library/Application Support/nushell/ by default on macOS
# Create symlinks to XDG location for cross-platform config
echo "  Linking nushell config for macOS..."
mkdir -p "$HOME/Library/Application Support/nushell"
ln -sf "$HOME/.config/nushell/env.nu" "$HOME/Library/Application Support/nushell/env.nu"
ln -sf "$HOME/.config/nushell/config.nu" "$HOME/Library/Application Support/nushell/config.nu"

# Step 4: Setup mise runtimes (after config is stowed)
echo ""
echo "Step 4: Setting up mise..."
if [ -f "$DOTFILES_DIR/mise/setup.sh" ]; then
    "$DOTFILES_DIR/mise/setup.sh"
fi

# Step 5: Setup VS Code (different path on macOS)
echo ""
echo "Step 5: Setting up VS Code..."
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"

if [ -d "$VSCODE_USER_DIR" ] || mkdir -p "$VSCODE_USER_DIR"; then
    # Symlink settings
    for file in settings.json keybindings.json; do
        src="$DOTFILES_DIR/vscode/.config/Code/User/$file"
        dest="$VSCODE_USER_DIR/$file"
        if [ -f "$src" ]; then
            rm -f "$dest"
            ln -sv "$src" "$dest"
        fi
    done

    # Symlink snippets directory
    if [ -d "$DOTFILES_DIR/vscode/.config/Code/User/snippets" ]; then
        rm -rf "$VSCODE_USER_DIR/snippets"
        ln -sv "$DOTFILES_DIR/vscode/.config/Code/User/snippets" "$VSCODE_USER_DIR/snippets"
    fi
fi

# Install VS Code extensions
echo "Installing VS Code extensions..."
install_ext() {
    code --uninstall-extension "$1" 2>/dev/null || true
    code --install-extension "$1" || true
}

install_ext enkia.tokyo-night
install_ext subframe7536.custom-ui-style
install_ext golang.go
install_ext ms-python.python
install_ext dbaeumer.vscode-eslint
install_ext prettier.prettier-vscode
install_ext ms-azuretools.vscode-docker
install_ext ms-vscode-remote.remote-containers

# Copy custom extensions
if [ -d "$DOTFILES_DIR/vscode/extensions" ]; then
    echo "Installing custom VS Code extensions..."
    mkdir -p "$HOME/.vscode/extensions"
    cp -r "$DOTFILES_DIR/vscode/extensions"/* "$HOME/.vscode/extensions/"
fi

# Step 6: Setup piper-speak (TTS for Claude Code hooks)
echo ""
echo "Step 6: Setting up piper-speak..."
export PATH="$HOME/.local/share/mise/shims:$PATH"
PIPER_SPEAK_DIR="$HOME/Developer/piper-speak"
if [ -d "$PIPER_SPEAK_DIR" ]; then
    cd "$PIPER_SPEAK_DIR"
    go build -o piper-speak ./cmd/piper-speak/
    sudo install -m755 piper-speak /usr/local/bin/piper-speak
    sudo install -m755 scripts/speak-selection-macos /usr/local/bin/speak-selection-macos

    # Install speak-claude scripts from dotfiles bin
    for script in speak-claude-permission speak-claude-question speak-claude-response; do
        if [ -f "$DOTFILES_DIR/bin/.local/bin/$script" ]; then
            sudo install -m755 "$DOTFILES_DIR/bin/.local/bin/$script" /usr/local/bin/
        fi
    done

    # Download voice model if not present
    VOICE_DIR="$HOME/.local/share/piper/voices"
    if [ ! -f "$VOICE_DIR/en_US-lessac-medium.onnx" ]; then
        echo "  Downloading voice model..."
        mkdir -p "$VOICE_DIR"
        curl -L "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx" \
            -o "$VOICE_DIR/en_US-lessac-medium.onnx"
        curl -L "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx.json" \
            -o "$VOICE_DIR/en_US-lessac-medium.onnx.json"
    fi
    cd "$DOTFILES_DIR"
else
    echo "  Skipping - clone piper-speak to ~/Developer/piper-speak first"
fi

# Step 7: Set nushell as default shell
echo ""
echo "Step 7: Setting default shell..."
NU_PATH=$(which nu)
if [ -n "$NU_PATH" ]; then
    if ! grep -q "$NU_PATH" /etc/shells; then
        echo "  Adding nushell to /etc/shells..."
        echo "$NU_PATH" | sudo tee -a /etc/shells
    fi
    if [ "$SHELL" != "$NU_PATH" ]; then
        echo "  Setting nushell as default shell..."
        chsh -s "$NU_PATH"
    else
        echo "  Nushell already default shell"
    fi
fi

echo ""
echo "=== Done! ==="
echo ""
echo "Notes:"
echo "  - VS Code custom-ui-style may need manual permission granting"
echo "  - Restart your terminal or run 'nu' to start using nushell"
