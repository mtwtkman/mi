#!/bin/bash
here="$(eval "${MI_ABSPATH_GETTER} $(dirname ${BASH_SOURCE[0]})")"
source "${here}/../modules/message.sh"

install_basic_packages()
{
  install_command="${1}"
  blue "Install basic packages."
  eval "${install_command}"
}

deploy_settings()
{
  blue "Deploy configs."
  pushd "${here}/../packages" &> /dev/null
  local target
  local -a targets=()
  if [ -n "${MI_PACKAGES:-}" ]; then
    read -r -a targets <<< "${MI_PACKAGES}"
  elif [ "${MI_PROFILE:-host}" = container ]; then
    targets=(git opencode)
  else
    targets=(*)
  fi
  for target in "${targets[@]}"
  do
    if [[ ! "$target" =~ ^[a-zA-Z0-9_-]+$ ]] || [ ! -d "${here}/../packages/${target}" ]; then
      red "Invalid or unknown package: ${target}"
      popd &> /dev/null
      return 1
    fi
    blue "Deploy ${target} configs."
    if bash "${here}/../modules/deploy.sh" "${target}"; then
      green "Done."
    else
      red "Failed to deploy ${target}."
      popd &> /dev/null
      return 1
    fi
  done
  popd &> /dev/null
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
