here="$(dirname ${BASH_SOURCE[0]})"

package_list="${here}/packages"
commands="${here}/commands"
config="${commands}/config"

echo "==== Start setup. ===="
sh "${commands}/config/prepare.sh"
sh "${commands}/helper/file/iter_active_rows.sh" ${package_list} "${commands}/entrypoint.sh"
echo "==== Finish setup. ===="
