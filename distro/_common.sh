#!/bin/bash
here="$(eval "${MI_ABSPATH_GETTER} $(dirname ${BASH_SOURCE[0]})")"
source "${here}/../modules/message.sh"

detect_architecture()
{
  case "$(uname -m)" in
    "x86_64") echo "amd64";;
    "aarch64") echo "arm64";;
  esac
}

detect_os()
{
  case "$(uname -o)" in
    "GNU/Linux" | "Android") echo "linux";;
    "Darwin") echo "darwin";;
  esac
}

# EXTERNAL PACKAGES
tmux_plugins_dir="${HOME}/.config/tmux/plugins"

## POI
install_poi()
{
  if  ! (command -v cabal && command -v ghc); then
    red "Required `cabal`, `ghc` to build poi from source"
    return
  fi
  blue "Install poi"
  workdir="poi-install-dir"
  if [ -d "${workdir}" ]; then
    /bin/rm -rf "${workdir}"
  fi
  mkdir "${workdir}"
  pushd "${workdir}" &> /dev/null
  git clone git@github.com:mtwtkman/poi
  cd poi
  mise release
  mv dest/poi "${HOME}/.local/bin"
  popd
  /bin/rm -rf "${workdir}"
  green "Done"
}

# BASIC PACKAGES
install_basic_packages()
{
  install_command="${1}"
  blue "Install basic packages."
  eval "${install_command}"
}


install_common_packages()
{
  blue "Install basic packages."
  # install_poi
  green "Done."
}

update_common_packages()
{
  # install_poi
}

deploy_settings()
{
  blue "Deploy configs."
  pushd "${here}/../packages" &> /dev/null
  for target in *
  do
    blue "Deploy ${target} configs."
    bash "${here}/../modules/deploy.sh" "${target}"
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
  cmd="${5}"
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
