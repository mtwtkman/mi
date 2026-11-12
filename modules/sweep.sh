#!/usr/bin/env bash
set -euo pipefail
repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
candidates=()

source "$repo/modules/select_packages.sh"
mi_select_packages "$repo"

for package in "${packages[@]}"; do
  package_dir="$repo/packages/$package"
  destination="$(cd -- "$package_dir" && bash ./location)"
  [[ -n "$destination" && "$destination" == /* ]] || {
    printf 'Invalid destination for package %s\n' "$package" >&2
    exit 1
  }
  if [[ -d "$package_dir/files" ]]; then
    while IFS= read -r -d '' source; do
      backup="$destination/${source##*/}.mi.bk"
      [[ -e "$backup" || -L "$backup" ]] && candidates+=("$backup")
    done < <(find "$package_dir/files" -mindepth 1 -maxdepth 1 -print0)
  elif [[ -d "$package_dir/this" ]]; then
    backup="${destination}.mi.bk"
    [[ -e "$backup" || -L "$backup" ]] && candidates+=("$backup")
  fi
done

if [[ "${#candidates[@]}" -eq 0 ]]; then
  printf 'No Mi backups found.\n'
  exit 0
fi

printf 'Mi backups to delete (%d):\n' "${#candidates[@]}"
printf '  %s\n' "${candidates[@]}"
if [[ ! -t 0 ]]; then
  printf 'Interactive confirmation required; nothing deleted.\n' >&2
  exit 1
fi
printf 'Delete these backups permanently? [y/N] '
read -r reply || exit 1
if [[ "$reply" != y && "$reply" != Y ]]; then
  printf 'Cancelled; nothing deleted.\n'
  exit 0
fi
for backup in "${candidates[@]}"; do
  rm -rf -- "$backup"
  printf 'Deleted: %s\n' "$backup"
done
