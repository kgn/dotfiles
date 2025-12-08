# hyprwhspr: Fix Wayland Environment Race Condition

## Status: Merged & Released

- **Pull Request**: https://github.com/goodroot/hyprwhspr/pull/35
- **Submitted**: 2025-12-07
- **Merged**: 2025-12-08
- **Released**: v1.8.11

---

## Summary

Fixed a race condition where the hyprwhspr systemd service starts before `WAYLAND_DISPLAY` is set in the user environment, causing text injection to silently fail.

## Problem

The service can start before the Wayland environment is fully initialized. When this happens, `wl-copy` fails because it cannot connect to the compositor:

```
Clipboard+hotkey injection failed: Command '['wl-copy']' returned non-zero exit status 1.
```

Symptoms:
- Recording works (chirp sound plays, waybar indicator changes)
- Transcription completes successfully
- No text is inserted into the focused application
- Restarting the service after login fixes the issue

## Solution

Replace the fixed 3-second sleep with a loop that waits for `WAYLAND_DISPLAY` to be set (up to 15 seconds):

```ini
[Service]
ExecStartPre=/bin/bash -c 'for i in $(seq 1 30); do [ -n "$WAYLAND_DISPLAY" ] && exit 0; sleep 0.5; done; echo "Warning: WAYLAND_DISPLAY not set after 15s"'
```

Benefits:
1. Exits immediately once the environment is ready (faster startup)
2. Handles systems where the graphical session takes longer to initialize
3. Provides a warning if the environment never becomes available

## Resolution

Fix included in hyprwhspr v1.8.11+. Local workaround removed.
