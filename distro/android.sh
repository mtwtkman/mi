here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

install_command="
  yes | pkg install \
    bash \
    bash-completion \
    bat \
    direnv \
    fd \
    fzf \
    gcc \
    git \
    jaq \
    make \
    man-db \
    neovim \
    ripgrep \
    slirp4netns \
    tmux \
    tree-sitter
"
update_command="yes | pkg update && yes | pkg upgrade"
purge_command="pkg autoclean"

cmd=$1
shift
source "${here}/_common.sh"
perform "${install_command}" "${update_command}" "${purge_command}" "${cmd}"
