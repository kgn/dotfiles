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
1. Install additional packages (nushell, vscode, claude-code, hyprwhspr, go, bun)
2. Remove unwanted packages (1password, libreoffice, signal)
3. Stow config files to override Omarchy defaults

## What's Included

| Directory | Description |
|-----------|-------------|
| `bash/` | Auto-launches nushell for interactive sessions |
| `nushell/` | Nushell config with starship, zoxide, mise |
| `starship/` | Custom prompt with colored segments |
| `hyprwhspr/` | Speech-to-text with Caps Lock trigger |
| `hypr/` | Hyprland overrides (keybindings, rounded corners) |
| `vscode/` | VS Code settings (minimal UI, git colors, custom styles) |
| `mise/` | Runtime version management (Go, Bun) |
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

## Update

```bash
cd ~/dotfiles
git pull
./install.sh
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
| [Hide SCM Input Box](vscode/feature-requests/hide-scm-input-box.md) | Cannot fully hide commit input boxes in VS Code Source Control panel - CSS hides content but 34px gap remains per repo | [vscode#281562](https://github.com/microsoft/vscode/issues/281562) |
