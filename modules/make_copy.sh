#!/bin/bash
set -euo pipefail
here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$here/message.sh"

src=${1:?Source path required}
dest=${2:?Destination path required}

[ -e "$src" ] || { printf 'Source does not exist: %s\n' "$src" >&2; exit 1; }
mkdir -p -- "$(dirname -- "$dest")"

# Do not rewrite an identical copy on repeated deploys.
if [ ! -L "$dest" ] && [ -e "$dest" ] && diff -qr -- "$src" "$dest" >/dev/null 2>&1; then
  exit 0
fi

bash "$here/backup_existing.sh" "$dest"

cp -a -- "$src" "$dest"
