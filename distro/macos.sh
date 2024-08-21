#!/bin/bash
here="$(readlink -f $(dirname ${BASH_SOURCE[0]}))"


install_command="
  /bin/bash -c "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew install \
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
    ripgrep \
    slirp4netns \
    tmux \
    tree-sitter
"
update_command="brew update"
purge_command="brew autoremove"

source "${here}/_common.sh"
perform "${install_command}" "${update_command}" "${purge_command}" "${1}"
