#!/bin/bash
here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

install_command = "
  yes | pkg install \
    bash \
    bash-completion \
    bat \
    direnv \
    fd-find \
    fzf \
    git \
    jq \
    make \
    neovim \
    ripgrep \
    tmux \
"
