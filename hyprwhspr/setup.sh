#!/bin/bash
# Setup hyprwhspr with fixes from fork until merged upstream
#
# Overrides from https://github.com/kgn/hyprwhspr:
# - PR #35: Fix Wayland environment race condition (wl-copy fails on startup)
#
# PR #33 (extended key support, key grabbing) is included in v1.8.0+
#
# See feature-requests/hyprwhspr-*.md for details.

set -e

HYPRWHSPR_REPO="$HOME/Development/hyprwhspr"

echo "Setting up hyprwhspr fixes..."

if [ ! -d "$HYPRWHSPR_REPO" ]; then
    git clone https://github.com/kgn/hyprwhspr.git "$HYPRWHSPR_REPO"
else
    git -C "$HYPRWHSPR_REPO" pull
fi

# Override systemd service (PR #35 - not yet merged)
cp "$HYPRWHSPR_REPO/config/systemd/hyprwhspr.service" "$HOME/.config/systemd/user/"
systemctl --user daemon-reload

echo "hyprwhspr systemd service updated"
