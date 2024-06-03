here="$(dirname ${BASH_SOURCE[0]})"

module="${here}/module"
prompt="${module}/helper/prompt"
config="${module}/config"
bootstrap="${here}/bootstrap"

sh "${prompt}/blue.sh" "==== Start setup. ===="
sh "${module}/install.sh"
sh "${module}/deploy.sh"
sh "${module}/user-bin/update.sh"
sh "${prompt}/blue.sh" "==== Finish setup. ===="
