#!/usr/bin/env bash
set -euo pipefail

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
[[ $# -eq 0 ]] || { printf 'Usage: mi sweep\n' >&2; exit 1; }

# Resolve HOME before location scripts change directories. For selected
# sweeps, keep inherited host XDG_CONFIG_HOME out of the target HOME.
if [[ "$(uname -s)" == Darwin ]]; then
  HOME="$(realpath "$HOME")" || exit 1
else
  HOME="$(readlink -m -- "$HOME")" || exit 1
fi
export HOME
if [[ -n "${MI_PACKAGES:-}" ]]; then
  export XDG_CONFIG_HOME="$HOME/.config"
fi

candidates=()
source "$repo/modules/select_packages.sh"
mi_select_packages "$repo"

collect() {
  local prefix="$1" backup
  # Include legacy and timestamped backups for this managed destination.
  if [[ -e "$prefix" || -L "$prefix" ]]; then
    candidates+=("$prefix")
  fi
  # Glob is confined to locations derived from Mi packages, not a recursive search.
  for backup in "$prefix".*; do
    if [[ -e "$backup" || -L "$backup" ]]; then
      candidates+=("$backup")
    fi
  done
  return 0
}

for package in "${packages[@]}"; do
  package_dir="$repo/packages/$package"
  destination="$(cd -- "$package_dir" && bash ./location)"
  [[ -n "$destination" && "$destination" == /* ]] || {
    printf 'Invalid destination for package %s\n' "$package" >&2
    exit 1
  }
  if [[ -d "$package_dir/files" ]]; then
    while IFS= read -r -d '' source; do
      collect "$destination/${source##*/}.mi.bk"
    done < <(find "$package_dir/files" -mindepth 1 -maxdepth 1 -print0)
  elif [[ -d "$package_dir/this" ]]; then
    collect "${destination}.mi.bk"
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
