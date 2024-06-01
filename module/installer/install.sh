here="$(dirname ${BASH_SOURCE[0]})"

helper="${here}/../helper"
package_name="${1}"

if [ $(sh "${helper}/host/has_command.sh" "${package_name}") = $(sh "${helper}/bool/true.sh") ]; then
  sh "${yello}" "SKIP: ${package_name} has been installed"
  exit 0
fi

sh "${helper}/host/skip_known_command_installation.sh" "${pacakge_name}" "${here}/do_install.sh"
