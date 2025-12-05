# hyprwhspr: Extended Key Support and Input Fixes

## Status: Submitted

- **Pull Request**: https://github.com/goodroot/hyprwhspr/pull/33
- **Submitted**: 2025-12-05
- **Status**: Open

---

## Summary

Added support for punctuation, symbols, and numbers in shortcuts, and fixed an issue where the shortcut key would be typed into the focused application.

## Changes

### 1. Extended Key Aliases

Added support for punctuation, symbols, and numbers in shortcuts:

```python
# Punctuation and symbols
'.': 'KEY_DOT', ',': 'KEY_COMMA', '/': 'KEY_SLASH',
'-': 'KEY_MINUS', '=': 'KEY_EQUAL', ';': 'KEY_SEMICOLON', ...

# Numbers
'0': 'KEY_0', '1': 'KEY_1', ... '9': 'KEY_9'

# Lowercase letters
'a': 'KEY_A', 'b': 'KEY_B', ... 'z': 'KEY_Z'
```

This allows using shortcuts like `SUPER+.` or `SUPER+1` instead of only function keys and letters.

### 2. Shortcut Key Suppression

Fixed an issue where the shortcut key would be typed into the focused application. For example, with `SUPER+.` as the shortcut, pressing it would insert a `.` into the text field before the transcribed text appeared.

Added keyboard grabbing via UInput virtual keyboard - hyprwhspr intercepts keyboard events and re-emits only the keys that aren't part of the shortcut.

Config option `grab_keys` (default: `true`):

```json
{
    "primary_shortcut": "SUPER+.",
    "grab_keys": true
}
```

### 3. Exact Modifier Matching

Shortcuts now only trigger on exact modifier matches. For example, `SUPER+.` won't trigger when pressing `SUPER+SHIFT+.`, allowing other applications to use that combination.

## Context

In my [dotfiles](https://github.com/kgn/dotfiles), I use two related keybindings:

- **SUPER + .** (hold) - Dictation via hyprwhspr (push-to-talk mode)
- **SUPER + SHIFT + .** - Speak selected text via [Piper TTS](https://github.com/rhasspy/piper)

This requires hyprwhspr to:
1. Support `.` (period) as a shortcut key
2. Not interfere with SUPER+SHIFT+. (only trigger on exact SUPER+.)
3. Not leak the `.` keypress to the focused application when dictating
