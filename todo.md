# TODO: installation script

Create an idempotent installation script for deploying these dotfiles on
Artix/Arch Linux.

## Requirements

- [x] Add an `install.sh` entry point with `set -euo pipefail`.
- [x] Detect Artix/Arch Linux and verify that required commands are available.
- [x] Support installing all components or selected components:
  - `niri`
  - `noctalia`
  - `nvim`
  - `zsh`
  - `ghostty`
  - `starship`
  - `fastfetch`
  - `elx`
- [x] Create relative symbolic links from the repository into `~/.config`.
- [x] Handle `zsh/.zshrc` separately by linking it to `~/.zshrc`.
- [x] Never overwrite an existing file silently.
- [x] Back up conflicting files into a timestamped directory and print its path.
- [x] Make repeated runs safe and leave correct existing links unchanged.
- [x] Add a `--dry-run` option that prints every planned change.
- [x] Add a non-interactive `--yes` option.
- [x] Add `--help` with usage and examples.
- [x] Keep package installation optional and show the required `pacman` command
      before asking for confirmation.
- [x] Install or update `wallfetch`, `desktop-stack`, `fzf-tab`, `elx`, and
      `tutors` when their components are selected.
- [x] Print a concise summary of installed, skipped, and backed-up items.

## Validation

- [x] Run `shellcheck` on the installer.
- [x] Test installation in a temporary HOME directory.
- [x] Test a clean install, repeated install, conflicting files, component
      selection, `--dry-run`, and missing dependencies.
- [x] Document installation, update, uninstall, and recovery steps in `README.md`.
