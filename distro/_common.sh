#!/bin/bash
set -ex
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
asdf_dir="${HOME}/.asdf"
tmux_plugins_dir="${HOME}/.config/tmux/plugins"

## ASDF
install_asdf()
{
  dest="asdf.zip"
  bindir="${HOME}/.local/bin"
  pushd "${bindir}" &> /dev/null
  target="-$(detect_os)-$(detect_architecture).tar.gz$"
  for candidate in $(curl https://api.github.com/repos/asdf-vm/asdf/releases/latest | jaq '.assets[].browser_download_url')
  do
    src=$(echo "${candidate}" | sed -E 's/^"(.*)"$/\1/g')
    if [ "${downloaded}" = "true" ]; then
      break
    fi
    if [[ $src =~ ${target} ]]; then
      blue "Download from ${src} to install asdf."
      curl -L "${src}" -o "${dest}"
      blue "Downloaded latest version archive."
      downloaded="true"
    fi
  done
  if [ ! -f "${dest}" ]; then
    red "Cannot detect."
    exit 1
    return
  fi

  tar -xf "${dest}"
  /bin/rm -rf "${dest}"
  blue "Installed asdf"
  popd
}

depends_on_asdf()
{
  if [ ! -d "${asdf_dir}" ]; then
    install_asdf
  fi
}

## PYTHON
install_python3()
{
  blue "Install python3"
  depends_on_asdf
  asdf plugin add python
  asdf install python latest
  asdf set -u python latest
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

## POI
install_poi()
{
  blue "Install poi"
  curl -ks https://api.github.com/repos/mtwtkman/poi/releases/latest | rg 'browser_download_url' | cut -d : -f 2,3 | tr -d \" | xargs curl -L  -o $HOME/.local/bin/poi
  chmod +x $HOME/.local/bin/poi
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
  install_asdf
  install_python3
  install_neovim_remote
  install_poi
  green "Done."
}

update_common_packages()
{
  install_asdf
  upgrade_pip
  install_poi
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
