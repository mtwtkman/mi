here="$(dirname ${BASH_SOURCE[0]})"

prompt="${here}/module/helper/prompt"

package="${1}"
package_path="${here}/packages-custom/${pacakge}"

if [ ! -d "${package_path" ]; then
  sh "${prompt}/red.sh" "Cannot find ${pacakge}."
  exit 0
fi

sh "${package_path}/install.sh"
