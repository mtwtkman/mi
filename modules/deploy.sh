#!/bin/bash
set -e
here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "${here}/message.sh"

target=${1:?Package name required}
cd -- "${here}/../packages/${target}"
dest="$(bash ./location)"
[ -n "$dest" ] || { printf 'Empty destination for %s\n' "$target" >&2; exit 1; }

create_link()
{
  if [ "${MI_DEPLOY_MODE:-link}" = copy ]; then
    bash "${here}/make_copy.sh" "$1" "$2"
  else
    bash "${here}/make_link.sh" "$1" "$2"
  fi
  green "Deployed ${MI_DEPLOY_MODE:-link} of $1 to $2"
}

if [ -d "files" ]; then
  mkdir -p -- "$dest"
  while IFS= read -r -d '' f; do
    src="$(cd -- "$(dirname -- "$f")" && pwd)/$(basename -- "$f")"
    create_link "$src" "$dest/$(basename -- "$src")"
  done < <(find ./files -maxdepth 1 -mindepth 1 -print0)
elif [ -d "this" ]; then
  create_link "$(pwd)/this" "$dest"
else
  red "Cannot find config files."
  exit 1
fi
