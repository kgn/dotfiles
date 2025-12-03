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
| `hypr/` | Custom keybindings (VSCode, Gmail, Google Calendar) |
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
├── hypr/.config/hypr/bindings.conf
├── scripts/
│   ├── packages.sh
│   └── cleanup.sh
├── install.sh
└── README.md
```
