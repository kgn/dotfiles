#!/bin/bash
# Piper TTS setup - installs piper-speak from https://github.com/kgn/piper-speak

set -e

PIPER_SPEAK_REPO="$HOME/Development/piper-speak"

echo "Setting up piper-speak..."

if [ ! -d "$PIPER_SPEAK_REPO" ]; then
    git clone https://github.com/kgn/piper-speak.git "$PIPER_SPEAK_REPO"
else
    git -C "$PIPER_SPEAK_REPO" pull
fi

"$PIPER_SPEAK_REPO/install.sh"
