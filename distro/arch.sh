#!/bin/bash
here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

function install_paru()
{
  currentdir=$(pwd)
  sudo pacman -Sy --noconfirm --needed base-devel
  workdir="/tmp/paru_build"
  mkdir $workdir
  cd $workdir
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  cd $currentdir
  /bin/rm -rf $workdir
}

install_command="
  ! command -v "paru" >/dev/null && eval \$(install_paru)
  paru -Sy --noconfirm \
    bash \
    bash-completion \
    bash-language-server \
    crun \
    foot \
    podman \
    podman-compose \
    distrobox \
    fd \
    fzf \
    gcc \
    jaq \
    libnotify \
    lua \
    luarocks
    make \
    mako \
    man-db \
    neovim \
    nnn \
    openssh \
    ripgrep \
    slirp4netns \
    tmux \
    ttf-hack-nerd \
    unzip
"
update_command="paru -Syu --noconfirm"
purge_command="paru -c --noconfirm"

source "${here}/_common.sh"
perform "${install_command}" "${update_command}" "${purge_command}" "${1}"
