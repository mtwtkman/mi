#!/bin/bash
here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

mi_install_packages() {
  sudo apt update || return
  sudo apt upgrade -y || return
  sudo apt install -y git build-essential || return

  local brew_bin
  if command -v brew >/dev/null 2>&1; then
    brew_bin="$(command -v brew)"
  else
    brew_bin="/home/linuxbrew/.linuxbrew/bin/brew"
    if [[ ! -x "$brew_bin" ]]; then
      # Preserve failures from either the download or the installer.
      (set -o pipefail; curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | NONINTERACTIVE=1 /bin/bash) || return
    fi
    if [[ ! -x "$brew_bin" ]]; then
      printf 'Homebrew installation did not create %s\n' "$brew_bin" >&2
      return 1
    fi
  fi

  "$brew_bin" install \
    bash \
    bat \
    podman \
    podman-compose \
    fd \
    fzf \
    gcc \
    jaq \
    make \
    man-db \
    neovim \
    ripgrep \
    tmux
}

mi_update_packages() {
  sudo apt update && sudo apt upgrade -y && brew update && brew upgrade
}

mi_purge_packages() {
  sudo apt autoclean && sudo apt autopurge && brew autoremove
}

source "${here}/_common.sh"
perform "$@"
