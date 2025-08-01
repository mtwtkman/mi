#!/bin/bash
here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

function install_fakeroot_tcp()
{
  currentdir=$(pwd)
  workdir="/tmp/facroot-build"
  makepkg --nobuild
  tar xf fakeroot_*.tar.gz
  cd fakeroot-*

  ./bootstrap
  ./configure --prefix=/usr --libdir=/usr/lib/fakeroot --with-ipc=tcp
  make
  sudo make install

  sudo su -
  cd $workdir
  cd fakeroot-*
  source PKGBUILD
  package
  exit
  cd $currentdir
  /bin/rm -rf $workdir
}

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
  sudo pacman -Sy --noconfirm \
    bash \
    bash-completion \
    bash-language-server \
    bat \
    crun \
    distrobox \
    fd \
    flatpak \
    fzf \
    gcc \
    git \
    jaq \
    make \
    man-db \
    neovim \
    openssh \
    podman \
    podman-compose \
    ripgrep \
    slirp4netns \
    tmux \
    tree-sitter \
    unzip
  eval $(install_fakeroot_tcp)
  eval $(install_yay)
"
update_command="yay -Syu --noconfirm"
purge_command="yay -Yc"

source "${here}/_common.sh"
perform "${install_command}" "${update_command}" "${purge_command}" "${1}"
