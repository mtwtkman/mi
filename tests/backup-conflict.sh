#!/usr/bin/env bash
set -euo pipefail
repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

command -v script >/dev/null || { echo 'script(1) required for interactive backup tests' >&2; exit 1; }

source_file="$tmp/source"
printf 'new\n' > "$source_file"
copy="$repo/modules/make_copy.sh"
link="$repo/modules/make_link.sh"

# Pipe input through a pseudo-TTY, since the handler deliberately reads /dev/tty.
answer() {
  local reply="$1" command="$2"
  printf '%s\n' "$reply" | script -q -e -c "$command" /dev/null > "$tmp/terminal.log"
}

# Copy mode: rotate old backup, preserve it, create a fresh backup.
dest="$tmp/copy"
printf 'current\n' > "$dest"
printf 'old-backup\n' > "$dest.mi.bk"
answer r "bash '$copy' '$source_file' '$dest'"
grep -qx new "$dest"
grep -qx current "$dest.mi.bk"
grep -qx old-backup "$dest.mi.bk.1"

# Repeated collisions choose the next unused suffix without overwriting.
printf 'current-2\n' > "$dest"
answer r "bash '$copy' '$source_file' '$dest'"
grep -qx old-backup "$dest.mi.bk.1"
grep -qx current "$dest.mi.bk.2"
grep -qx current-2 "$dest.mi.bk"

# Copy mode: explicit overwrite replaces only .mi.bk, not rotated backups.
printf 'current-3\n' > "$dest"
answer o "bash '$copy' '$source_file' '$dest'"
grep -qx current-3 "$dest.mi.bk"
grep -qx old-backup "$dest.mi.bk.1"
grep -qx current "$dest.mi.bk.2"
grep -qx new "$dest"

# Cancel leaves both paths untouched.
printf 'cancel-me\n' > "$dest"
if answer c "bash '$copy' '$source_file' '$dest'"; then
  echo 'FAIL: cancelled operation succeeded' >&2
  exit 1
fi
grep -qx cancel-me "$dest"
grep -qx current-3 "$dest.mi.bk"

# Without a terminal, do not overwrite backups or destinations.
if bash "$copy" "$source_file" "$dest" </dev/null >"$tmp/no-tty.log" 2>&1; then
  echo 'FAIL: non-interactive conflict succeeded' >&2
  exit 1
fi
grep -q 'interactive choice required' "$tmp/no-tty.log"
grep -qx cancel-me "$dest"
grep -qx current-3 "$dest.mi.bk"

# Directories are moved and replaced correctly as well.
dir="$tmp/config-dir"
mkdir -p "$dir" "$dir.mi.bk" "$tmp/config-src"
printf 'current\n' > "$dir/data"
printf 'original-backup\n' > "$dir.mi.bk/data"
printf 'fresh\n' > "$tmp/config-src/data"
answer r "bash '$copy' '$tmp/config-src' '$dir'"
grep -qx fresh "$dir/data"
grep -qx current "$dir.mi.bk/data"
grep -qx original-backup "$dir.mi.bk.1/data"

# Link mode uses the same policy; broken symlinks count as backups.
link_dest="$tmp/link"
printf 'link-current\n' > "$link_dest"
ln -s "$tmp/missing" "$link_dest.mi.bk"
answer r "bash '$link' '$source_file' '$link_dest'"
test -L "$link_dest"
test "$(readlink "$link_dest")" = "$source_file"
grep -qx link-current "$link_dest.mi.bk"
test -L "$link_dest.mi.bk.1"
test "$(readlink "$link_dest.mi.bk.1")" = "$tmp/missing"

echo 'Mi backup conflict regression tests passed.'
