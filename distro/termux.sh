#!/bin/bash
here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

termerx_conf="${HOME}/.termux"

function setup()
{
  if [[ -d "${termerx_conf}" ]]; then
    return
  fi
  mkdir "${termerx_conf}"
}

function setup_nerdfont()
{
  curl -L https://github.com/ryanoasis/nerd-fonts/raw/refs/heads/master/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf > "${termerx_conf}/font.ttf"
}

install_command="
  yes | pkg install \
    bash \
    bash-completion \
    bat \
    clang \
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
update_command="pkg update && yes | pkg upgrade && $(setup_nerdfont)"
purge_command="pkg autoclean"

cmd="${1}"

source "${here}/_common.sh"
perform "${install_command}" "${update_command}" "${purge_command}" "${cmd}"
