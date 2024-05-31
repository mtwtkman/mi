here="$(dirname ${BASH_SOURCE[0]})"

helper="${here}/../helper"
prompt="${helper}/prompt"
blue="${prompt}/blue.sh"
green="${prompt}/green.sh"
yellow="${prompt}/yellow.sh"
install_command=$(sh "${here}/detect_install_command.sh")
package_name="${1}"

if [ $(sh "${helper}/host/has_command.sh" "${package_name}") = $(sh "${helper}/bool/true.sh") ]; then
  sh "${yello}" "SKIP: ${package_name} has been installed"
  exit 0
fi

sh "${blue}" "INSTALL: ${package_name}"
eval "${install_command} ${package_name}"
sh "${green}" "INSTALLED: ${package_name}"
