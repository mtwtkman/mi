here="$(dirname ${BASH_SOURCE[0]})"

module="${here}/module"
prompt="${module}/helper/prompt"
config="${module}/config"
bootstrap="${here}/bootstrap"

sh "${prompt}/blue.sh" "==== Start setup. ===="
sh "${module}/config/prepare.sh"
sh "${bootstrap}/install.sh"
sh "${bootstrap}/deploy.sh"
sh "${module}/user-bin/update.sh"
sh "${prompt}/blue.sh" "==== Finish setup. ===="
