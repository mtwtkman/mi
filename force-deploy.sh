here="$(dirname ${BASH_SOURCE[0]})"

prompt="${here}/module/helper/prompt"

package="${1}"
package_dir="${here}/packages/${package}"

if [ ! -d "${package_dir}" ]; then
  sh "${prompt}/red.sh" "Cannot find a ${package}"
  exit 0
fi

deploy_sh="${package_dir}/deploy.sh"

if [ ! -f "${deploy_sh}" ]; then
  sh "${prompt}/red.sh" "Cannot find a `deploy.sh` at ${package_dir}."
  exit 0
fi

sh "${deploy_sh}"
