here="$(dirname ${BASH_SOURCE[0]})"

package_name="${1}"

eval "$(sh ${here}/pacman.sh) -Q ${package_name}" &> /dev/null
retVal="${?}"

if [ "${retVal}" = 0 ]; then
  sh "${here}/../../helper/bool/true.sh"
else
  sh "${here}/../../helper/bool/false.sh"
fi
