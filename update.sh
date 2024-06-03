here="$(dirname ${BASH_SOURCE[0]})"

package="${1}"
sh "${here}/force-install.sh" "${package}"
sh "${here}/force-deploy.sh" "${package}"
