#!/bin/bash
here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

install_command="
  yes | sudo pacman -Sy \
    bash \
    bash-completion \
    bash-language-server \
    bat \
    crun \
    distrobox \
    fd \
    flatpak \
    fzf \
    gcc \
    git \
    jaq \
    make \
    man-db \
    neovim \
    openssh \
    podman \
    podman-compose \
    ripgrep \
    slirp4netns \
    tmux \
    tree-sitter \
    unzip
"
update_command="yes | sudo pacman -Syu"
purge_command="pacman -Qqtd | sudo pacman -Rs -"

source "${here}/_common.sh"
perform "${install_command}" "${update_command}" "${purge_command}" "${1}"
