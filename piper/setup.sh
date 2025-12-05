#!/bin/bash
# Piper TTS setup - voice model installation

set -e

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
