# Dotfiles

Personal Omarchy customizations managed with [GNU Stow](https://www.gnu.org/software/stow/).

This repo overlays on top of a standard Omarchy installation - no fork required.

## Install

```bash
# 1. Install Omarchy (standard installation from ISO or online)
# https://omarchy.org

# 2. Clone dotfiles
git clone https://github.com/kgn/dotfiles ~/dotfiles

# 3. Run install script
cd ~/dotfiles
./install.sh

# 4. Log out and back in
```

The install script will:
1. Install additional packages (nushell, vscode, claude-code, hyprwhspr, piper-speak, go, bun)
2. Remove unused packages (1password, libreoffice, signal)
3. Stow config files to override Omarchy defaults

## Packages

| Package | Description |
|---------|-------------|
| [nushell](https://www.nushell.sh/) | Modern shell with structured data |
| [claude-code](https://claude.ai/claude-code) | Claude AI CLI assistant |
| [hyprwhspr](https://github.com/goodroot/hyprwhspr) | Speech-to-text dictation |
| [piper-speak](https://github.com/kgn/piper-speak) | Text-to-speech via Piper TTS |
| [visual-studio-code-bin](https://code.visualstudio.com/) | Code editor |
| [mise](https://mise.jdx.dev/) | Runtime version manager (Go, Bun) |
| [atuin](https://atuin.sh/) | Shell history search |
| [carapace-bin](https://carapace.sh/) | Shell completions |

## Config Directories

| Directory | Description |
|-----------|-------------|
| `bash/` | Auto-launches nushell for interactive sessions |
| `nushell/` | Nushell config with starship, zoxide, mise |
| `starship/` | Custom prompt with colored segments |
| `hyprwhspr/` | Speech-to-text config (SUPER+. to dictate) |
| `hypr/` | Hyprland overrides (keybindings, rounded corners) |
| `vscode/` | VS Code settings (minimal UI, git colors, custom styles) |
| `mise/` | Runtime version management (Go, Bun) |
| `claude/` | Claude Code settings and TTS hooks |
| `bin/` | Custom scripts (~/.local/bin) |
| `scripts/` | Package install/cleanup scripts |

## Keybinding Changes

Removed:
- `SUPER SHIFT + G` - Signal (removed)
- `SUPER SHIFT + /` - 1Password (removed)

Changed:
- `SUPER SHIFT + C` - Google Calendar (was HEY)
- `SUPER SHIFT + E` - Gmail (was HEY)

Added:
- `SUPER SHIFT + V` - VSCode
- `SUPER + .` - Dictation (hold to record, release to transcribe)
- `SUPER + SHIFT + .` - Speak selected text via [piper-speak](https://github.com/kgn/piper-speak) (press again to stop)

## VS Code

Minimal UI with custom styling via [Custom UI Style](https://marketplace.visualstudio.com/items?itemName=nicool.custom-ui-style) extension.

**Hidden elements:**
- Title bar and window controls
- Menu bar, tabs, breadcrumbs
- Status bar, minimap, scrollbars
- SCM commit input box and sync buttons

**Git colors** (Tokyo Night theme):
- Staged: green (`#9ece6a`)
- Modified: yellow (`#e0af68`)
- Untracked: blue (`#7aa2f7`)
- Added: cyan (`#73daca`)
- Deleted: red (`#f7768e`)

**Keybindings:**
- `Ctrl+Shift+C` - Copy relative file path
- `Ctrl+O` - Open folder

## Update

```bash
cd ~/dotfiles
git pull
./install.sh
```

## Bluetooth Headset Mic

To use a Bluetooth headset's microphone (for dictation/speech-to-text):

```bash
bt-headset-mode on   # Enable mic (lower audio quality)
bt-headset-mode off  # High quality audio (no mic)
```

Note: Bluetooth can't do high quality audio AND mic simultaneously.

## Dictation Customization

hyprwhspr supports word corrections and custom prompts in `~/.config/hyprwhspr/config.json`:

```json
{
    "word_overrides": {
        "val runner": "val-runner",
        "hyper whisper": "hyprwhspr"
    },
    "whisper_prompt": "Transcribe code terms: val-runner, hyprwhspr, Hyprland."
}
```

- **word_overrides** - Auto-replace transcribed words (corrections file)
- **whisper_prompt** - Guide Whisper with context about expected terms

## Claude Code Hooks

Claude Code is configured with hooks that use [piper-speak](https://github.com/kgn/piper-speak) to speak aloud:

| Hook | Trigger | Behavior |
|------|---------|----------|
| `PreToolUse` | AskUserQuestion tool | Speaks the question (summarized via Haiku if >100 chars) |
| `PermissionRequest` | Any permission prompt | Speaks the tool description |
| `Stop` | Response complete | Speaks the response (summarized via Haiku if >200 chars) |

This enables hands-free awareness of Claude's status while multitasking.

Configuration in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "AskUserQuestion",
      "hooks": [{ "type": "command", "command": "speak-claude-question" }]
    }],
    "PermissionRequest": [{
      "hooks": [{ "type": "command", "command": "speak-claude-permission" }]
    }],
    "Stop": [{
      "hooks": [{ "type": "command", "command": "speak-claude-response" }]
    }]
  }
}
```

## Manual Commands

```bash
# Stow a single package
stow -t ~ nushell

# Remove a stowed package
stow -t ~ -D nushell

# Install only packages (no stow)
./scripts/packages.sh

# Remove unwanted packages only
./scripts/cleanup.sh
```

## Structure

```
dotfiles/
├── bash/.bashrc
├── nushell/.config/nushell/
│   ├── config.nu
│   └── env.nu
├── starship/.config/starship.toml
├── hyprwhspr/.config/hyprwhspr/config.json
├── hypr/.config/hypr/
│   ├── bindings.conf
│   └── looknfeel.conf
├── vscode/.config/Code/User/
│   └── settings.json
├── mise/.config/mise/
│   └── config.toml
├── claude/.claude/
│   └── settings.json
├── bin/.local/bin/
│   ├── bt-headset-mode
│   └── speak-claude-*
├── scripts/
│   ├── packages.sh
│   └── cleanup.sh
├── install.sh
└── README.md
```

## Outstanding Enhancements

Workarounds or features waiting on upstream changes:

| Issue | Description | Status |
|-------|-------------|--------|
| [Hide SCM Input Box](feature-requests/hide-scm-input-box.md) | Cannot fully hide commit input boxes in VS Code Source Control panel - CSS hides content but 34px gap remains per repo | [PR #281627](https://github.com/microsoft/vscode/pull/281627) |
