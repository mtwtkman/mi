here="$(dirname ${BASH_SOURCE[0]})"

package="${1}"
sh "${here}/force-install-custom.sh" "${package}"
sh "${here}/force-deploy-custom.sh" "${package}"
