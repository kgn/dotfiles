#!/bin/bash
# Setup hyprwhspr with latest features from main branch
#
# The AUR package (v1.7.2) doesn't yet include PR #33 which adds:
# - Extended key support (punctuation, numbers)
# - Key grabbing (prevents shortcut key from being typed)
# - Exact modifier matching (SUPER+. won't trigger on SUPER+SHIFT+.)
#
# This script overrides the installed files with the latest main branch.
# Remove this override once AUR updates to v1.7.3+

set -e

HYPRWHSPR_REPO="$HOME/Development/hyprwhspr"

echo "Updating hyprwhspr with latest main branch..."

if [ ! -d "$HYPRWHSPR_REPO" ]; then
    git clone https://github.com/goodroot/hyprwhspr.git "$HYPRWHSPR_REPO"
else
    git -C "$HYPRWHSPR_REPO" pull
fi

sudo cp "$HYPRWHSPR_REPO/lib/src/global_shortcuts.py" /usr/lib/hyprwhspr/lib/src/
sudo cp "$HYPRWHSPR_REPO/lib/main.py" /usr/lib/hyprwhspr/lib/

echo "hyprwhspr updated with extended key support and key grabbing"
