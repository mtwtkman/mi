#!/usr/bin/env bash
# Shared package selection for deploy and sweep.
# Caller sets repo and receives the selected packages in the 'packages' array.
mi_select_packages() {
  local repo="${1:?Repository root required}"
  local package_dir package
  packages=()
  if [[ -n "${MI_PACKAGES:-}" ]]; then
    read -r -a packages <<< "${MI_PACKAGES}"
  elif [[ "${MI_PROFILE:-host}" == container ]]; then
    packages=(git opencode neovim)
  else
    for package_dir in "$repo"/packages/*; do
      [[ -d "$package_dir" ]] && packages+=("${package_dir##*/}")
    done
  fi
  for package in "${packages[@]}"; do
    if [[ ! "$package" =~ ^[a-zA-Z0-9_-]+$ || ! -d "$repo/packages/$package" ]]; then
      printf 'Invalid or unknown package: %s\n' "$package" >&2
      return 1
    fi
  done
}
