here="$(dirname ${BASH_SOURCE[0]})"
abshere="$(readlink -m ${here})"

link_maker="${here}/../../module/helper/file/refresh_link.sh"
sh "${link_maker}" "${abshere}/.bash_profile" "${HOME}/.bash_profile"
sh "${link_maker}" "${abshere}/.bashrc" "${HOME}/.bashrc"
