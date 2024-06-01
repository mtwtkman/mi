here="$(dirname ${BASH_SOURCE[0]})"

package_list="${here}/packages"
module="${here}/module"
prompt="${module}/helper/prompt"
config="${module}/config"

sh "${prompt}/blue.sh" "==== Start setup. ===="
sh "${module}/config/prepare.sh"
sh "${module}/helper/file/iter_active_rows.sh" ${package_list} "${module}/bootstrap.sh"
sh "${module}/user-bin/update.sh"
sh "${module}/installer/install_extra.sh"
sh "${prompt}/blue.sh" "==== Finish setup. ===="
