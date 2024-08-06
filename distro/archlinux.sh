here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"
common="${here}/_common.sh"

source "${here}/../modules/message.sh"

install_basic_packages()
{
  blue "Install basic packages."
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
  if [ $? != 0 ]; then
    red "Abort."
    exit 0
  fi
}

install_external_packages()
{
  blue "Install basic packages."
  source "${common}"
  load_asdf
  load_catppuccin_tmux
  install_python3
  install_neovim_remote
  green "Done."
}

deploy_settings()
{
  blue "Deploy configs."
  pushd "${here}/../packages" &> /dev/null
  for target in *
  do
    blue "Deploy ${target} configs."
    sh "${here}/../modules/deploy.sh" "${target}"
    green "Done."
  done
  popd &> /dev/null
  green "Done."

  blue "Deploy update script."
  update_script="${HOME}/.local/bin/update"
  echo "sudo pacman -Syu" > "${update_script}"
  yellow "Created ${update_script}"
  green "Done."
}

update_packages()
{

  source "${common}"
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
