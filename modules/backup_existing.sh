#!/usr/bin/env bash
set -euo pipefail

dest=${1:?Destination path required}
[[ -e "$dest" || -L "$dest" ]] || exit 0

# UTC seconds keep names readable. An incrementing suffix prevents collisions
# from multiple deployments in the same second or a pre-existing backup.
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
base="${dest}.mi.bk.${stamp}"
backup="$base"
n=1
while [[ -e "$backup" || -L "$backup" ]]; do
  backup="${base}.${n}"
  ((n+=1))
done

# GNU mv -n can report success without moving; fail if the destination
# unexpectedly appears rather than risking an overwrite.
[[ ! -e "$backup" && ! -L "$backup" ]] || {
  printf 'Backup destination already exists: %s\n' "$backup" >&2
  exit 1
}
mv -- "$dest" "$backup"
printf 'Created backup for %s as %s\n' "$dest" "$backup"
