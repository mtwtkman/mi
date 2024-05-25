here=./$(dirname "${BASH_SOURCE[0]}")

package_list="${here}/packages"
commands="${here}/commands"
packages="${commands}/packages"
config="${commands}/config"

echo "==== Start setup. ===="
sh "${commands}/installer/iter_install.sh" "${packages}"
sh "${commands}/config/prepare.sh"
sh "${commands}/config/iter_deploy.sh" "${packages}"
echo "==== Finish setup. ===="
