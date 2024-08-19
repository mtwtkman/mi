here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

source "${here}/../modules/message.sh"

# EXTERNAL PACKAGES
asdf_dir="${HOME}/.asdf"
tmux_plugins_dir="${HOME}/.config/tmux/plugins"

## ASDF
load_asdf()
{
  blue "Load asdf"
  if [ ! -d "${asdf_dir}" ]; then
    git clone https://github.com/asdf-vm/asdf.git "${asdf_dir}" --branch master
  fi
  pushd "${asdf_dir}" &> /dev/null
  git fetch
  git reset --hard origin/master
  popd &> /dev/null
  green "Done"
}

depends_on_asdf()
{
  if [ ! -d "${asdf_dir}" ]; then
    load_asdf
  fi
  source "${asdf_dir}/asdf.sh"
}

## TMUX
load_catppuccin_tmux()
{
  blue "Load catppuccin-tmux"
  dest="${tmux_plugins_dir}/catppuccin"
  if [ ! -d ${dest} ]; then
    mkdir -p "${dest}"
    git clone https://github.com/catppuccin/tmux "${dest}"
  fi

  pushd "${dest}" &> /dev/null
  git fetch
  git reset --hard origin/HEAD
  popd &> /dev/null
  green "Done"
}

## PYTHON
install_python3()
{
  blue "Install python3"
  depends_on_asdf
  asdf plugin add python
  asdf install python latest
  asdf global python latest
  green "Done"
}

upgrade_pip()
{
  blue "Upgrade pip"
  depends_on_python3
  pip install --upgrade pip
  green "Done"
}

depends_on_python3()
{
  if ! command -v "python" &> /dev/null; then
    install_python3
  fi
}

## NEOVIM
install_neovim_remote()
{
  blue "Install neovim-remote"
  depends_on_python3
  pip3 install neovim-remote
  asdf reshim python
  green "Done"
}

# BASIC PACKAGES
install_basic_packages()
{
  install_command="${1}"
  blue "Install basic packages."
  eval "${install_command}"
  if [ $? != 0 ]; then
    red "Abort."
    exit 1
  fi
}


install_common_packages()
{
  blue "Install basic packages."
  load_asdf
  load_catppuccin_tmux
  install_python3
  install_neovim_remote
  green "Done."
}

update_common_packages()
{
  load_asdf
  load_catppuccin_tmux
  upgrade_pip
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
}

# ENTRYPOINT

perform()
{
  install_command="${1}"
  update_command="${2}"
  purge_command="${3}"
  target_command="${4}"
  case "${target_command}" in
    install)
      install_basic_packages "${install_command}"
      deploy_settings
      install_common_packages
      ;;
    deploy) deploy_settings;;
    update)
      eval "${update_command}"
      update_common_packages
      ;;
    purge)
      eval "${purge_command}"
      ;;
    *)
      red "Available commands are: install,deploy,update,purge"
      exit 1
      ;;
  esac
}
