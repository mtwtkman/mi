here="$(dirname ${BASH_SOURCE[0]})"

helper="${here}/../helper"
package_name="${1}"
checker=$(sh "${here}/detect_installed_checker.sh")
prompt="${here}/../helper/prompt"
t="$(sh ${helper}/bool/true.sh)"

if [ $(sh "${helper}/host/has_command.sh" "${package_name}") = "${t}" ] || [ $(sh "${checker}" "${package_name}") = "${t}" ]; then
  sh "${prompt}/yellow.sh" "SKIP: ${package_name} has been installed"
  exit 0
fi

sh "${helper}/host/skip_known_command_installation.sh" "${package_name}" "${here}/do_install.sh"
