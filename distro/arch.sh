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
  #eval \$(install_paru)
  sudo paru -Sy --noconfirm \
    avizo \
    bash \
    bash-completion \
    bash-language-server \
    bat \
    crun \
    podman \
    podman-compose \
    distrobox \
    fd \
    flatpak \
    fzf \
    gcc \
    jaq \
    libnotify \
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
    tree-sitter \
    unzip

  paru -Syu --noconfirm ttf-hack-nerd kitty
"
update_command="paru -Syu --noconfirm"
purge_command="paru -c --noconfirm"

source "${here}/_common.sh"
perform "${install_command}" "${update_command}" "${purge_command}" "${1}"
