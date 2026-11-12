#!/usr/bin/env bash
# Integration test: deploy every package using an isolated temporary HOME.
set -euo pipefail

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT
export HOME="$tmp/home"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
mkdir -p -- "$HOME"

fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }

# Validate every location before running the complete deployment.
# This is a lexical check, not a security boundary against hostile scripts.
for location in "$repo"/packages/*/location; do
  dest="$(bash "$location")"
  case "$dest" in
    "$HOME"|"$HOME"/*) ;;
    *) fail "Package location escapes test HOME: $location -> $dest" ;;
  esac
done

# Use the normal CLI, but never invoke install/update/purge.
DISTRO=arch bash "$repo/mi" deploy
test -L "$HOME/.config/nvim" || fail "Neovim link missing"
test "$(readlink "$HOME/.config/nvim")" = "$repo/packages/neovim/this" || fail "Neovim target mismatch"
test -L "$HOME/.config/opencode" || fail "OpenCode link missing"
test "$(readlink "$HOME/.config/opencode")" = "$repo/packages/opencode/this" || fail "OpenCode target mismatch"

# The second deployment should not create backup files for unchanged links.
DISTRO=arch bash "$repo/mi" deploy
if find "$HOME" -name '*.mi.bk' -print -quit | grep -q .; then
  fail "Repeated deployment created backup files"
fi

# Verify all symlinks remain within the expected repository.
while IFS= read -r -d '' link; do
  target="$(readlink "$link")"
  case "$target" in
    "$repo"/packages/*) ;;
    *) fail "Unexpected symlink target: $link -> $target" ;;
  esac
done < <(find "$HOME" -type l -print0)

echo 'PASS: full Mi deploy in temporary HOME (including repeat run)'
