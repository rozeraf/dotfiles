#!/usr/bin/env bash

set -euo pipefail

REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
TEST_ROOT=$(mktemp -d)
trap 'rm -rf -- "$TEST_ROOT"' EXIT

fail() {
	printf 'FAIL: %s\n' "$*" >&2
	exit 1
}

run_installer() {
	HOME=$TEST_ROOT "$REPO_DIR/install.sh" \
		--platform artix \
		--components starship \
		--no-packages \
		--no-extras \
		--yes \
		"$@"
}

printf 'test: clean install\n'
run_installer >/dev/null
target="$TEST_ROOT/.config/starship.toml"
[[ -L $target ]] || fail "starship config was not linked"
[[ $(realpath -- "$target") == "$REPO_DIR/starship/starship.toml" ]] || fail "link points to the wrong source"

printf 'test: repeated install\n'
output=$(run_installer)
[[ $output == *"skipped:  1"* ]] || fail "repeated install was not skipped"

printf 'test: conflicting file backup\n'
rm -- "$target"
printf 'local config\n' > "$target"
run_installer >/dev/null
[[ -L $target ]] || fail "conflicting file was not replaced with a link"
backup=$(find "$TEST_ROOT/.local/state/dotfiles-backups" -type f -name starship.toml -print -quit)
[[ -n $backup ]] || fail "conflicting file was not backed up"
[[ $(<"$backup") == "local config" ]] || fail "backup content changed"

printf 'test: dry run\n'
rm -- "$target"
HOME=$TEST_ROOT "$REPO_DIR/install.sh" \
	--platform artix \
	--components starship \
	--no-packages \
	--no-extras \
	--dry-run \
	--yes >/dev/null
[[ ! -e $target && ! -L $target ]] || fail "dry run changed the target"

printf 'test: uninstall\n'
run_installer >/dev/null
run_installer --uninstall >/dev/null
[[ ! -e $target && ! -L $target ]] || fail "uninstall did not remove the managed link"

printf 'test: missing repository dependency\n'
fake_bin="$TEST_ROOT/fake-bin"
mkdir -p -- "$fake_bin"
printf '#!/usr/bin/env bash\nexit 1\n' > "$fake_bin/pacman"
chmod +x "$fake_bin/pacman"
if PATH="$fake_bin:$PATH" HOME=$TEST_ROOT "$REPO_DIR/install.sh" \
	--platform artix \
	--components starship \
	--dry-run \
	--no-extras \
	--yes >/dev/null 2>&1; then
	fail "missing repository dependency was not detected"
fi

printf 'PASS\n'
