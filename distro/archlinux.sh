here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

install_command="
  yes | sudo pacman -Sy \
    bash \
    bash-completion \
    bash-language-server \
    bat \
    crun \
    direnv \
    fd \
    fzf \
    gcc \
    git \
    jaq \
    make \
    man-db \
    neovim \
    podman \
    ripgrep \
    slirp4netns \
    tmux \
    tree-sitter
"
update_command="yes | sudo pacman -Syu"
purge_command="pacman -Qqd | sudo pacman -Rsu -"

cmd=$1
shift
source "${here}/_common.sh"
perform "${install_command}" "${update_command}" "${purge_command}" "${cmd}"
