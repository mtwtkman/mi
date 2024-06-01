here="$(dirname ${BASH_SOURCE[0]})"

package_name="${1}"
install_sh="${2}"

if [ $(sh "${here}/has_command.sh" "${package_name}") = "${here}/../bool/true.sh" ]; then
  exit 0;
else
  sh "${install_sh}" "${package_name}"
fi
