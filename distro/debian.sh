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

update_latest_neovim=$(cat <<EOF
  current_latest_release_version="$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jaq '.tag_name' | rg '(v\d+\.\d+\.\d+)' -or '$1')"
  current_nvim_version="$(nvim -v | rg 'NVIM (v\d+\.\d+\.\d+)' -or '$1')"
  [[ "${current_latest_release_version}" -eq "${current_nvim_version}" ]] && return

  eval "${install_latest_neovim}"
EOF
)

install_command="
  sudo apt update
  sudo apt upgrade -y
  sudo apt install -y git
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  brew install \
    bash \
    bash-completion \
    bat \
    distrobox \
    fd-find \
    fzf \
    gcc \
    jq \
    make \
    man-db \
    neovim \
    ripgrep \
    tmux \
    libtree-sitter-dev
  ln -s $(which fdfind) ~/.local/bin/fd
  ${install_latest_neovim}
"
update_command="sudo apt update && sudo apt upgrade -y; ${update_lateste_neovim}"
purge_command="sudo apt autoclean && sudo apt autopuge"

source "${here}/_common.sh"
perform "${install_command}" "${update_command}" "${purge_command}" "${1}"
