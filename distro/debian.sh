#!/bin/bash
here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

install_latest_neovim=$(cat <<EOF
  working_dir="/tmp/install-neovim"
  pushd "${working_dir}"
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
  tar xzvf nvim-linux-arm64.tar.gz
  mv nvim-linux-arm64 ~/.local/nvim
  ln -s ~/.local/nvim/bin/nvim ~/.local/bin/nvim
  popd
EOF
)

install_command="
  sudo apt update
  sudo apt upgrade -y
  sudo apt install -y git
  yes "" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  sudo apt install -y build-essential

  brew install \
    bash \
    bat \
    podman \
    podman-compose \
    distrobox \
    fd \
    fzf \
    gcc \
    jaq \
    make \
    man-db \
    neovim \
    nnn \
    ripgrep \
    tmux
"
update_command="sudo apt update && sudo apt upgrade -y; brew update && brew upgrade"
purge_command="sudo apt autoclean && sudo apt autopuge; brew autoremove"

source "${here}/_common.sh"
perform "${install_command}" "${update_command}" "${purge_command}" "${1}"
