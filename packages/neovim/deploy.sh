here="$(dirname ${BASH_SOURCE[0]})"
abshere="$(readlink -m ${here})"

sh "${here}/../../module/helper/file/refresh_link.sh" "${abshere}/config" "${HOME}/.config/nvim"
