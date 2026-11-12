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

if [ -e "$dest" ] || [ -L "$dest" ]; then
  backup="${dest}.mi.bk"
  if [ -e "$backup" ] || [ -L "$backup" ]; then
    printf 'Backup already exists: %s\n' "$backup" >&2
    exit 1
  fi
  mv -- "$dest" "$backup"
  yellow "Create backup file for $dest as $backup"
fi
ln -s -- "$src" "$dest"
