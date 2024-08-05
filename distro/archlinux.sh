here="$(dirname ${BASH_SOURCE[0]})"

source "${here}/../modules/message.sh"

install_basic_packages()
{
  blue "Install packages."
  sudo pacman -Syu
  sudo pacman -Sy \
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
    podman \
    ripgrep \
    slirp4netns \
    tmux \
    tree-sitter
}

install_external_packages()
{
  source "${here}/_common.sh"
  load_asdf
  load_catppuccin_tmux
  install_python3
  install_neovim_remote
  green "Done."
}

deploy_settings()
{
  blue "Deploy settings."
  pushd packages &> /dev/null
  for target in *
  do
    yellow "=> Deploy ${target} configs."
    sh "${here}/modules/deploy.sh" "${target}"
    yellow "==> Done."
  done
  popd &> /dev/null
  green "Done."

  blue "Deploy update script."
  echo "sudo pacman -Syu" > "${HOME}/.local/bin/update"
  green "Done."
}

update_packages()
{
  sudo pacman -Syu
  source "${here}/_common.sh"
  load_asdf
  load_catppuccin_tmux
  upgrade_pip
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
    install_external_packages
    ;;
  deploy) deploy_settings;;
  update) update_packages;;
  purge)
    pacman -Qqd | sudo pacman -Rsu -
    ;;
  *) usage
    exit 0
    ;;
esac
