#!/usr/bin/env bash
set -euo pipefail

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

export HOME="$tmp/home"
export XDG_CONFIG_HOME="$HOME/.config"
mkdir -p -- "$HOME"

link="$repo/modules/make_link.sh"
source_file="$tmp/source"
destination="$HOME/.config/example"
printf 'source\n' > "$source_file"

bash "$link" "$source_file" "$destination"
test -L "$destination"
test "$(readlink "$destination")" = "$source_file"

# Re-running with an unchanged target must not create a backup.
bash "$link" "$source_file" "$destination"
test ! -e "$destination.mi.bk"

# Existing user files must be backed up.
rm -- "$destination"
printf 'original\n' > "$destination"
bash "$link" "$source_file" "$destination"
grep -qx original "$destination.mi.bk"

# Existing backups must never be overwritten.
rm -- "$destination"
printf 'new user file\n' > "$destination"
if bash "$link" "$source_file" "$destination"; then
  echo 'FAIL: overwrote an existing backup' >&2
  exit 1
fi
grep -qx original "$destination.mi.bk"
grep -qx 'new user file' "$destination"

# Missing source is an error.
if bash "$link" "$tmp/missing" "$tmp/absent"; then
  echo 'FAIL: missing source was accepted' >&2
  exit 1
fi

# Both 'this' and 'files' packages must deploy into the temporary HOME.
bash "$repo/modules/deploy.sh" neovim
test -L "$HOME/.config/nvim"
test "$(readlink "$HOME/.config/nvim")" = "$repo/packages/neovim/this"

bash "$repo/modules/deploy.sh" opencode
test -L "$HOME/.config/opencode"
test "$(readlink "$HOME/.config/opencode")" = "$repo/packages/opencode/this"

# XDG override must be honored for opencode.
export XDG_CONFIG_HOME="$HOME/xdg-config"
bash "$repo/modules/deploy.sh" opencode
test -L "$XDG_CONFIG_HOME/opencode"

# Full deploy should be confined to the temporary HOME and repeatable.
export XDG_CONFIG_HOME="$HOME/.config"
export DISTRO=ubuntu
bash "$repo/mi" deploy
bash "$repo/mi" deploy

test -L "$HOME/.config/nvim"
test -L "$HOME/.config/opencode"
test -L "$HOME/.config/git"
test -L "$HOME/.bashrc"
test -f "$HOME/.config/systemd/user/ssh-agent.service"
grep -Fq "ExecStart=/usr/bin/ssh-agent -D -a %t/ssh-agent.sock" "$HOME/.config/systemd/user/ssh-agent.service"
test ! -e "$HOME/.config/nvim.mi.bk"
test ! -e "$HOME/.config/opencode.mi.bk"

# A broken symlink is an existing destination and must be backed up.
broken="$HOME/broken"
ln -s "$tmp/nonexistent-target" "$broken"
bash "$link" "$source_file" "$broken"
test -L "$broken.mi.bk"
test "$(readlink "$broken.mi.bk")" = "$tmp/nonexistent-target"
test "$(readlink "$broken")" = "$source_file"

# Container profile: deploy independent copies, not symlinks.
container_home="$tmp/container-home"
mkdir -p "$container_home"
export HOME="$container_home"
export XDG_CONFIG_HOME="$HOME/.config"
export MI_PROFILE=container
unset MI_PACKAGES MI_DEPLOY_MODE
bash "$repo/mi" deploy
test -d "$HOME/.config/git"
test ! -L "$HOME/.config/git"
test -d "$HOME/.config/opencode"
test ! -L "$HOME/.config/opencode"
test ! -e "$HOME/.config/foot"
test ! -e "$HOME/.bashrc"
test ! -e "$HOME/.config/systemd/user/ssh-agent.service"
bash "$repo/mi" deploy
test ! -e "$HOME/.config/opencode.mi.bk"

# Opt-in package selection for an additional 'this' package.
export MI_PACKAGES="neovim"
bash "$repo/mi" deploy
test -d "$HOME/.config/nvim"
test ! -L "$HOME/.config/nvim"

# A modified file is backed up, and a second conflicting change is rejected.
unset MI_PACKAGES
printf 'modified\n' > "$HOME/.config/opencode/mi-regression-test"
bash "$repo/mi" deploy
test -d "$HOME/.config/opencode.mi.bk"
test -f "$HOME/.config/opencode.mi.bk/mi-regression-test"
printf 'modified again\n' > "$HOME/.config/opencode/mi-regression-test"
if bash "$repo/mi" deploy; then
  echo 'FAIL: existing container backup was overwritten' >&2
  exit 1
fi
test -f "$HOME/.config/opencode/mi-regression-test"

# Invalid package selections must fail through the top-level CLI.
export MI_PACKAGES="does-not-exist"
if bash "$repo/mi" deploy; then
  echo 'FAIL: unknown package unexpectedly succeeded' >&2
  exit 1
fi
unset MI_PACKAGES

# Container profile must never invoke package managers.
if bash "$repo/mi" install; then
  echo 'FAIL: container install unexpectedly succeeded' >&2
  exit 1
fi

# A custom user unit must never be replaced.
unset MI_PROFILE MI_PACKAGES
export HOME="$tmp/custom-home"
export XDG_CONFIG_HOME="$HOME/.config"
mkdir -p "$XDG_CONFIG_HOME/systemd/user"
printf 'custom unit\n' > "$XDG_CONFIG_HOME/systemd/user/ssh-agent.service"
if bash "$repo/modules/linux_user.sh"; then
  echo 'FAIL: custom SSH agent unit was overwritten or accepted' >&2
  exit 1
fi
grep -qx 'custom unit' "$XDG_CONFIG_HOME/systemd/user/ssh-agent.service"
echo 'All Mi deployment regression tests passed.'
