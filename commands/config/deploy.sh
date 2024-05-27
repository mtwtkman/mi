here="$(dirname ${BASH_SOURCE[0]})"

package_name="${1}"
package_setting_dir="${here}/../../pakcage/${package_name}"

if [ ! -d "${package_name}" ]; then
  exit 0
fi

sh "${here}../helper/prompt/blue.sh" "DEPLOY: ${package_name}"
sh "${here}/../../package/${package_name}/deploy.sh"
sh "${here}../helper/prompt/green.sh" "DEPLOIED: ${package_name}"
