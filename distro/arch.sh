#!/bin/bash
here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

function install_paru()
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

install_command="
  command -v paru >/dev/null || install_paru
  paru -S --needed --noconfirm \
    bash \
    bash-completion \
    bash-language-server \
    crun \
    foot \
    flatpak \
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
    nnn \
    openssh \
    rebuild-detector \
    ripgrep \
    slirp4netns \
    sway-audio-idle-inhibit-git \
    tmux \
    ttf-hack-nerd \
    unzip \
    wl-clipboard
"
update_command="paru -Syu --noconfirm && checkrebuild"
purge_command="paru -c --noconfirm"

source "${here}/_common.sh"
perform "${install_command}" "${update_command}" "${purge_command}" "${1}"
