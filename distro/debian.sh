#!/bin/bash
here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

install_command="
  yes | sudo apt install \
    bash \
    bash-completion \
    bash-language-server \
    bat \
    crun \
    direnv \
    fd \
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
    tree-sitter
"
update_command="yes | sudo apt-get update"
purge_command="sudo apt autoclean && sudo apt autopuge"

source "${here}/_common.sh"
perform "${install_command}" "${update_command}" "${purge_command}" "${1}"