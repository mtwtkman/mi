#!/bin/bash
here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "${here}/../modules/message.sh"
source "${here}/../modules/select_packages.sh"

install_basic_packages()
{
  install_command="${1}"
  blue "Install basic packages."
  eval "${install_command}"
}

deploy_settings()
{
  blue "Deploy configs."
  local target
  local -a packages=()
  mi_select_packages "$here/.." || return 1
  for target in "${packages[@]}"
  do
    blue "Deploy ${target} configs."
    if bash "${here}/../modules/deploy.sh" "${target}"; then
      green "Done."
    else
      red "Failed to deploy ${target}."
      return 1
    fi
  done
  if [ "$(uname -s)" = Linux ] && [ "${MI_PROFILE:-host}" != container ]; then
    bash "${here}/../modules/linux_user.sh" || return 1
  fi
  green "Done."
}

perform()
{
  install_command="${1}"
  update_command="${2}"
  purge_command="${3}"
  target_command="${4}"
  case "${target_command}" in
    install)
      install_basic_packages "${install_command}" || return 1
      deploy_settings
      ;;
    deploy) deploy_settings;;
    update)
      eval "${update_command}"
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
