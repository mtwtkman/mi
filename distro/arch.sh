#!/bin/bash
here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

function install_yay()
{
  currentdir=$(pwd)
  sudo pacman -Sy --noconfirm --needed base-devel
  workdir="/tmp/aur_build"
  mkdir $workdir
  cd $workdir
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  cd $currentdir
  /bin/rm -rf $workdir
}

install_command="
  sudo pacman -Sy --noconfirm --needed base-devel git
  eval \$(install_yay)
  sudo yay -Sy --noconfirm \
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
    make \
    man-db \
    neovim \
    openssh \
    ripgrep \
    slirp4netns \
    tmux \
    ttf-hack-nerd \
    tree-sitter \
    unzip

  yay -Syu --noconfirm ttf-hack-nerd kitty
"
update_command="yay -Syu --noconfirm"
purge_command="yay -Yc"

source "${here}/_common.sh"
perform "${install_command}" "${update_command}" "${purge_command}" "${1}"
