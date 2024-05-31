here="$(dirname ${BASH_SOURCE[0]})"

package_name="${1}"

sh "${here}/installer/install.sh" "${package_name}"
sh "${here}/config/deploy.sh" "${package_name}"
