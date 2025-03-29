#!/bin/bash
here="$(eval "${MI_ABSPATH_GETTER} $(dirname ${BASH_SOURCE[0]})")"
source "${here}/../modules/message.sh"

# BASIC PACKAGES
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
