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

echo 'All Mi deployment regression tests passed.'
