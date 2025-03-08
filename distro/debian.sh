#!/bin/bash
here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

install_command="
  yes | sudo apt install \
    bash \
    bash-completion \
    bat \
    fd-find \
    fzf \
    gcc \
    git \
    jq \
    make \
    man-db \
    neovim \
    ripgrep \
    tmux \
    libtree-sitter-dev
"
update_command="yes | sudo apt-get update"
purge_command="sudo apt autoclean && sudo apt autopuge"

source "${here}/_common.sh"
perform "${install_command}" "${update_command}" "${purge_command}" "${1}"
