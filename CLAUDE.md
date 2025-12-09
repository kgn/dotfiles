# Dotfiles Repository

## Key Principle

The `install.sh` script should fully configure the system. Users should only need to run `./install.sh` once to set everything up. Avoid requiring manual steps after installation.

## Structure

- Each directory is a stow package that gets symlinked to `$HOME`
- Exception: `hypr/` files are individually symlinked (Hyprland manages other files in that directory)
- `scripts/` contains helper scripts called by `install.sh`
- `feature-requests/` tracks upstream feature requests/PRs

## Stow Packages

Packages stowed via install.sh: `bash`, `nushell`, `starship`, `hyprwhspr`, `vscode`, `mise`, `bin`, `claude`, `waybar`

Not stowed (have setup scripts instead): `docker/`, `vscode/` extensions

## When Making Changes

- Edit files in this dotfiles repo, not the symlinked config files directly
- After adding new config files, run `./install.sh` to create symlinks
- Keep the `.gitignore` updated for files that shouldn't be tracked (e.g., history files)
- If adding a new stow package, add it to the `packages` array in `install.sh`

## Important Files

- `install.sh` - Main installer, runs in order: packages -> mise -> cleanup -> stow -> vscode -> docker
- `scripts/packages.sh` - Pacman and AUR packages to install
- `scripts/cleanup.sh` - Packages and web apps to remove
- `hypr/.config/hypr/bindings.conf` - Keybindings (not stowed, symlinked individually)

## Git Commits

- Never mention Claude or AI in commit messages
- Do not include "Co-Authored-By" or "Generated with" lines
