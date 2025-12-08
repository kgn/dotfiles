# hyprwhspr: Fix Wayland Environment Race Condition

## Status: Follow-up PR Submitted

- **Original PR**: https://github.com/goodroot/hyprwhspr/pull/35 (v1.8.11)
- **Follow-up PR**: https://github.com/goodroot/hyprwhspr/pull/37
- **Submitted**: 2025-12-08

---

## Summary

Fixed a race condition where the hyprwhspr systemd service starts before Wayland is ready, causing text injection to silently fail.

## Problem

The service can start before the Wayland compositor is fully initialized. When this happens, `wl-copy` fails because it cannot connect to the compositor:

```
Clipboard+hotkey injection failed: Command '['wl-copy']' returned non-zero exit status 1.
```

Symptoms:
- Recording works (chirp sound plays, waybar indicator changes)
- Transcription completes successfully
- No text is inserted into the focused application
- Restarting the service after login fixes the issue

## Original Solution (PR #35 - Incomplete)

The first fix waited for `WAYLAND_DISPLAY` environment variable:

```ini
ExecStartPre=/bin/bash -c 'for i in $(seq 1 30); do [ -n "$WAYLAND_DISPLAY" ] && exit 0; sleep 0.5; done; echo "Warning: WAYLAND_DISPLAY not set after 15s"'
```

**Why it didn't work:** Systemd user services don't inherit environment variables from the graphical session. The env var is never set in the service's environment, so the check always times out.

## Correct Solution (PR #37)

Check for the Wayland socket file directly instead of the environment variable:

```ini
ExecStartPre=/bin/bash -c 'for i in $(seq 1 30); do ls /run/user/$(id -u)/wayland-* >/dev/null 2>&1 && exit 0; sleep 0.5; done; echo "Warning: Wayland socket not found after 15s"'
```

The socket file (`/run/user/$UID/wayland-*`) is created when the compositor starts and reliably indicates Wayland is ready.

## Workaround

Until PR #37 is merged, restart the service after login:

```bash
systemctl --user restart hyprwhspr
```
