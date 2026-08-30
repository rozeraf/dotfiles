# TODO: installation script

Create an idempotent installation script for deploying these dotfiles on
Artix/Arch Linux.

## Requirements

- [ ] Add an `install.sh` entry point with `set -euo pipefail`.
- [ ] Detect Artix/Arch Linux and verify that required commands are available.
- [ ] Support installing all components or selected components:
  - `niri`
  - `noctalia`
  - `nvim`
  - `zsh`
  - `kitty`
  - `starship`
  - `fastfetch`
  - `elx`
- [ ] Create relative symbolic links from the repository into `~/.config`.
- [ ] Handle `zsh/.zshrc` separately by linking it to `~/.zshrc`.
- [ ] Never overwrite an existing file silently.
- [ ] Back up conflicting files into a timestamped directory and print its path.
- [ ] Make repeated runs safe and leave correct existing links unchanged.
- [ ] Add a `--dry-run` option that prints every planned change.
- [ ] Add a non-interactive `--yes` option.
- [ ] Add `--help` with usage and examples.
- [ ] Keep package installation optional and show the required `pacman` command
      before asking for confirmation.
- [ ] Detect and report optional external dependencies such as `wallfetch`,
      `desktop-stack`, `fzf-tab`, and the Kitty clipboard helper.
- [ ] Print a concise summary of installed, skipped, backed-up, and failed items.

## Validation

- [ ] Run `shellcheck` on the installer.
- [ ] Test installation in a temporary HOME directory.
- [ ] Test a clean install, repeated install, conflicting files, component
      selection, `--dry-run`, and missing dependencies.
- [ ] Document installation, update, uninstall, and recovery steps in `README.md`.
