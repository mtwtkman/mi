#!/usr/bin/env bash
set -euo pipefail
repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
candidates=()

# Only inspect backup paths corresponding to configured Mi package destinations.
if [[ -n "${MI_PACKAGES:-}" ]]; then
  read -r -a packages <<< "${MI_PACKAGES}"
elif [[ "${MI_PROFILE:-host}" == container ]]; then
  packages=(git opencode)
else
  packages=()
  for package_dir in "$repo"/packages/*; do
    [[ -d "$package_dir" ]] && packages+=("${package_dir##*/}")
  done
fi

for package in "${packages[@]}"; do
  if [[ ! "$package" =~ ^[a-zA-Z0-9_-]+$ || ! -d "$repo/packages/$package" ]]; then
    printf 'Invalid or unknown package: %s\n' "$package" >&2
    exit 1
  fi
  package_dir="$repo/packages/$package"
  destination="$(cd -- "$package_dir" && bash ./location)"
  [[ -n "$destination" && "$destination" == /* ]] || {
    printf 'Invalid destination for package %s\n' "$package" >&2
    exit 1
  }
  if [[ -d "$package_dir/files" ]]; then
    for source in "$package_dir/files"/*; do
      [[ -e "$source" || -L "$source" ]] || continue
      backup="$destination/${source##*/}.mi.bk"
      [[ -e "$backup" || -L "$backup" ]] && candidates+=("$backup")
    done
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
