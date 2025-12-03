# Dotfiles Repository

## Key Principle

The `install.sh` script should fully configure the system. Users should only need to run `./install.sh` once to set everything up. Avoid requiring manual steps after installation.

## Structure

- Each directory is a stow package that gets symlinked to `$HOME`
- `scripts/` contains helper scripts called by `install.sh`

## When Making Changes

- Edit files in this dotfiles repo, not the symlinked config files directly
- After adding new config files, run `./install.sh` to create symlinks
- Keep the `.gitignore` updated for files that shouldn't be tracked (e.g., history files)
