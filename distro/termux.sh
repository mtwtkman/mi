#!/bin/bash
here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

install_command="
  yes | pkg install \
    bash \
    bash-completion \
    bat \
    direnv \
    fd \
    fzf \
    git \
    jq \
    make \
    man \
    neovim \
    ripgrep \
    tmux \
"

update_command="pkg update && yes | pkg upgrade"
purge_command="pkg autoclean"

source "${here}/_common.sh"
perform "${install_command}" "${update_command}" "${purge_command}" "${1}"
