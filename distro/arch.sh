#!/bin/bash
here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

install_paru()
{
  currentdir=$(pwd)
  sudo pacman -S --noconfirm --needed base-devel
  workdir="/tmp/paru_build"
  mkdir $workdir
  cd $workdir
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  cd $currentdir
  /bin/rm -rf $workdir
}

mi_install_packages() {
  command -v paru >/dev/null || install_paru || return 1
  paru -S --needed --noconfirm \
    bash \
    bash-completion \
    bash-language-server \
    crun \
    foot \
    podman \
    podman-compose \
    fd \
    fzf \
    gcc \
    jaq \
    kanshi \
    libnotify \
    lua \
    luarocks \
    make \
    mako \
    man-db \
    neovim \
    openssh \
    rebuild-detector \
    ripgrep \
    slirp4netns \
    sway-audio-idle-inhibit-git \
    tmux \
    ttf-hack-nerd \
    unzip \
    wl-clipboard
}

mi_update_packages() {
  paru -Syu --noconfirm && checkrebuild
}

mi_purge_packages() {
  paru -c --noconfirm
}

source "${here}/_common.sh"
perform "$@"
