here="$(dirname ${BASH_SOURCE[0]})"
abshere="$(readlink -m ${here})"

file_helper="${here}/../../module/helper/file"
dest="${HOME}/.config/git"
sh "${file_helper}/create_directory_if_necessary.sh" "${dest}"
sh "${file_helper}/refresh_link.sh" "${abshere}/config" "${dest}/config"
