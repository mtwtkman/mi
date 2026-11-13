#!/bin/bash
here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "${here}/../modules/message.sh"
source "${here}/../modules/select_packages.sh"
source "${here}/../modules/boxkit.sh"

install_basic_packages()
{
  blue "Install basic packages."
  mi_install_packages
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
  local target_command="${1}"
  case "${target_command}" in
    install)
      install_basic_packages || return 1
      if [[ "${MI_PROFILE:-host}" != container ]]; then
        mi_boxkit_install || return 1
      fi
      deploy_settings
      ;;
    deploy) deploy_settings;;
    update)
      local failed=0
      blue "Updating system packages."
      if ! mi_update_packages; then
        red "Package update failed."
        failed=1
      fi
      if [[ "${MI_PROFILE:-host}" != container ]]; then
        blue "Updating Boxkit (Git checkout)."
        if ! mi_boxkit_update; then
          red "Boxkit update failed."
          failed=1
        fi
      fi
      return "$failed"
      ;;
    purge)
      mi_purge_packages
      ;;
    *)
      red "Available commands are: install,deploy,update,purge"
      exit 1
      ;;
  esac
}
