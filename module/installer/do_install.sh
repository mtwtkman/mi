here="$(dirname ${BASH_SOURCE[0]})"

helper="${here}/../helper"
prompt="${helper}/prompt"
package_name="${1}"
install_command=$(sh "${here}/detect_install_command.sh")

sh "${prompt}/blue.sh" "INSTALL: ${package_name}"
eval "${install_command} ${package_name}"
sh "${prompt}/green.sh" "INSTALLED: ${package_name}"
