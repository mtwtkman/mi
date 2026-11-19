#!/bin/bash
set -e
here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "${here}/message.sh"

src=${1:?Source path required}
dest=${2:?Destination path required}

if [ ! -e "$src" ]; then
  printf 'Source does not exist: %s\n' "$src" >&2
  exit 1
fi

mkdir -p -- "$(dirname -- "$dest")"
if [ -L "$dest" ] && [ "$(readlink -- "$dest")" = "$src" ]; then
  exit 0
fi

bash "$here/backup_existing.sh" "$dest"
ln -s -- "$src" "$dest"
