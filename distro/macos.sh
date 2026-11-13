#!/bin/bash
here="$(readlink -f $(dirname ${BASH_SOURCE[0]}))"

mi_install_packages() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || return 1
  /opt/homebrew/bin/brew install \
    bash \
    bash-completion \
    bash-language-server \
    bat \
    fd \
    fzf \
    gcc \
    git \
    jaq \
    make \
    man-db \
    neovim \
    nnn \
    openssh \
    docker \
    docker-compose \
    ripgrep \
    tmux \
    trash
}

mi_update_packages() {
  brew update
}

mi_purge_packages() {
  brew autoremove
}

source "${here}/_common.sh"
perform "${1:-}"
