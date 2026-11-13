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

# A failing AUR package must not prevent independently managed tools from
# updating. Preserve a failing exit status after attempting every stage.
arch_update()
{
  local failed=0

  if paru -Syu --noconfirm; then
    if ! checkrebuild; then
      red "checkrebuild failed."
      failed=1
    fi
  else
    red "Package update failed."
    failed=1
  fi

  if [[ "${MI_PROFILE:-host}" != container ]]; then
    if ! mi_boxkit_update; then
      red "Boxkit update failed."
      failed=1
    fi
  fi

  return "$failed"
}

if [[ "${1}" == update ]]; then
  arch_update
else
  perform "${install_command}" "${update_command}" "${purge_command}" "${1}"
fi
