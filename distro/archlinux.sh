here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

source "${here}/_common.sh"
source "${here}/../modules/message.sh"

install_basic_packages()
{
  blue "Install basic packages."
  yes | sudo pacman -Syu
  yes | sudo pacman -Sy \
    bash \
    bash-completion \
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
  if [ $? != 0 ]; then
    red "Abort."
    exit 1
  fi
}

update_basic_packages()
{
  yes | sudo pacman -Syu
}

usage()
{
  echo "./archlinux (install|update|purge)"
}

cmd=$1
shift
case $cmd in
  install)
    install_basic_packages
    deploy_settings
    install_common_packages
    ;;
  deploy) deploy_settings;;
  update)
    update_basic_packages
    update_common_packages
    ;;
  purge)
    pacman -Qqd | sudo pacman -Rsu -
    ;;
  *) usage
    exit 0
    ;;
esac
