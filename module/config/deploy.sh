here="$(dirname ${BASH_SOURCE[0]})"

package_name="${1}"
package_setting_dir="${here}/../../packages/${package_name}"
prompt="${here}/../helper/prompt"

if [ ! -d "${package_setting_dir}" ]; then
  exit 0
fi

sh "${prompt}/blue.sh" "DEPLOY: ${package_name}"
sh "${package_setting_dir}/deploy.sh"
sh "${prompt}/green.sh" "DEPLOIED: ${package_name}"
