here="$(dirname ${BASH_SOURCE[0]})"

package_list="${here}/packages"
commands="${here}/commands"
prompt="${commands}/helper/prompt"
config="${commands}/config"

sh "${prompt}/blue.sh" "==== Start setup. ===="
sh "${commands}/config/prepare.sh"
sh "${commands}/helper/file/iter_active_rows.sh" ${package_list} "${commands}/entrypoint.sh"
sh "${prompt}/green.sh" "==== Finish setup. ===="
