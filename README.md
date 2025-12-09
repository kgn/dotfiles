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
| [claude-code](https://claude.ai/claude-code) | CLI assistant |
| [hyprwhspr](https://github.com/goodroot/hyprwhspr) | Speech-to-text dictation |
| [piper-speak](https://github.com/kgn/piper-speak) | Text-to-speech via Piper TTS |
| [visual-studio-code-bin](https://code.visualstudio.com/) | Code editor |
| [mise](https://mise.jdx.dev/) | Runtime version manager (Go, Bun, Node) |
| [atuin](https://atuin.sh/) | Shell history search |
| [carapace-bin](https://carapace.sh/) | Shell completions |
| [pass](https://www.passwordstore.org/) | Password manager |
| [kubectl](https://kubernetes.io/docs/reference/kubectl/) | Kubernetes CLI |
| [kind](https://kind.sigs.k8s.io/) | Kubernetes in Docker |

## Config Directories

| Directory | Description |
|-----------|-------------|
| `bash/` | Auto-launches nushell for interactive sessions |
| `nushell/` | Nushell config with starship, zoxide, mise |
| `starship/` | Custom prompt with colored segments |
| `hyprwhspr/` | Speech-to-text config (SUPER+. to dictate) |
| `hypr/` | Hyprland overrides (keybindings, input, look and feel) |
| `vscode/` | VS Code settings (minimal UI, git colors, custom styles) |
| `mise/` | Runtime version management (Go, Bun, Node) |
| `claude/` | Claude Code settings and TTS hooks |
| `waybar/` | Custom waybar config |
| `docker/` | Docker daemon config (registry mirror, log rotation) |
| `bin/` | Custom scripts (~/.local/bin) |
| `scripts/` | Package install/cleanup scripts |
| `feature-requests/` | Tracking upstream feature requests |

## Keybinding Changes

Changed from default Omarchy:
- `SUPER SHIFT + C` - Google Calendar (was HEY)
- `SUPER SHIFT + E` - Gmail (was HEY)
- `SUPER SHIFT + G` - GitHub (was Signal)
- `SUPER SHIFT + /` - pass (was 1Password)
- `SUPER SHIFT + N` - VS Code
- `SUPER SHIFT ALT + A` - Claude (was Grok)

Added:
- `SUPER + .` - Dictation (hold to record, release to transcribe)
- `SUPER SHIFT + .` - Speak selected text via [piper-speak](https://github.com/kgn/piper-speak) (press again to stop)

## VS Code

Minimal UI with custom styling via [Custom UI Style](https://marketplace.visualstudio.com/items?itemName=nicool.custom-ui-style) extension.

**Hidden elements:**
- Title bar and window controls
- Menu bar, tabs, breadcrumbs
- Status bar, minimap, scrollbars
- SCM commit input box and action buttons (via native `git.showCommitInput` and `git.showActionButton` settings)

**Git colors** (Tokyo Night theme):
- Staged: green (`#9ece6a`)
- Modified: yellow (`#e0af68`)
- Untracked: blue (`#7aa2f7`)
- Added: cyan (`#73daca`)
- Deleted: red (`#f7768e`)

**Keybindings:**
- `Ctrl+Shift+C` - Copy relative file path
- `Ctrl+O` - Open folder

**Extensions installed by setup:**
- Tokyo Night theme
- Custom UI Style
- Go, Python, ESLint, Prettier, Docker

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
│   ├── input.conf
│   ├── looknfeel.conf
│   └── windows.conf
├── vscode/
│   ├── .config/Code/User/settings.json
│   ├── extensions/          # Custom extensions
│   └── setup.sh             # Extension installer
├── mise/
│   ├── .config/mise/config.toml
│   └── setup.sh             # Go tools installer
├── waybar/.config/waybar/config.jsonc
├── docker/
│   ├── daemon.json
│   └── setup.sh
├── claude/.claude/settings.json
├── bin/.local/bin/
│   ├── bt-headset-mode
│   └── speak-claude-*
├── scripts/
│   ├── packages.sh
│   └── cleanup.sh
├── feature-requests/        # Upstream feature tracking
├── install.sh
└── README.md
```

## Outstanding Enhancements

Feature requests and upstream contributions:

| Issue | Description | Status |
|-------|-------------|--------|
| [Key Grabbing](feature-requests/hyprwhspr-key-grabbing.md) | Extended key support and input fixes for hyprwhspr | Merged - v1.8.0 |
| [Wayland Race Fix](feature-requests/hyprwhspr-wayland-race.md) | hyprwhspr service starts before WAYLAND_DISPLAY is set | Merged - v1.8.11 |
| [Hide SCM Input Box](feature-requests/hide-scm-input-box.md) | Hide commit input box in Source Control panel | Closed - use `git.showCommitInput` |
