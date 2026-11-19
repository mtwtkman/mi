#!/usr/bin/env bash
set -euo pipefail
repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

source_file="$tmp/source"
printf 'new\n' > "$source_file"
copy="$repo/modules/make_copy.sh"
link="$repo/modules/make_link.sh"

# An existing legacy .mi.bk must not interfere with a new backup.
dest="$tmp/copy"
printf 'current\n' > "$dest"
printf 'old-backup\n' > "$dest.mi.bk"
bash "$copy" "$source_file" "$dest" </dev/null
grep -qx new "$dest"
grep -qx old-backup "$dest.mi.bk"
shopt -s nullglob
backups=("$dest".mi.bk.????????T??????Z*)
[[ "${#backups[@]}" -eq 1 ]]
grep -qx current "${backups[0]}"

# Multiple updates in the same second produce distinct paths.
printf 'current-2\n' > "$dest"
bash "$copy" "$source_file" "$dest" </dev/null
backups=("$dest".mi.bk.????????T??????Z*)
[[ "${#backups[@]}" -eq 2 ]]
grep -qx old-backup "$dest.mi.bk"
grep -qx current-2 "${backups[0]}" || grep -qx current-2 "${backups[1]}"
grep -qx current "${backups[0]}" || grep -qx current "${backups[1]}"

# An identical copy remains a no-op, without extra backups.
bash "$copy" "$source_file" "$dest" </dev/null
backups=("$dest".mi.bk.????????T??????Z*)
[[ "${#backups[@]}" -eq 2 ]]

# Directories and broken symlinks are preserved as backups too.
dir="$tmp/config-dir"
mkdir -p "$dir" "$tmp/config-src"
printf 'current\n' > "$dir/data"
printf 'fresh\n' > "$tmp/config-src/data"
bash "$copy" "$tmp/config-src" "$dir" </dev/null
dir_backups=("$dir".mi.bk.????????T??????Z*)
[[ "${#dir_backups[@]}" -eq 1 ]]
grep -qx current "${dir_backups[0]}/data"
grep -qx fresh "$dir/data"

link_dest="$tmp/link"
ln -s "$tmp/missing" "$link_dest"
bash "$link" "$source_file" "$link_dest" </dev/null
link_backups=("$link_dest".mi.bk.????????T??????Z*)
[[ "${#link_backups[@]}" -eq 1 ]]
test -L "${link_backups[0]}"
test "$(readlink "${link_backups[0]}")" = "$tmp/missing"
test -L "$link_dest"
test "$(readlink "$link_dest")" = "$source_file"

echo 'Mi timestamped backup regression tests passed.'
