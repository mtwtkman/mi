here="$(dirname ${BASH_SOURCE[0]})"
abshere="$(readlink -m ${here})"

file_helper="${here}/../../module/helper/file"

dest="${HOME}/.config/tmux"
sh "${file_helper}/create_directory_if_necessary.sh" "${dest}"

sh "${file_helper}/refresh_link.sh" "${abshere}/tmux.conf" "${dest}/tmux.conf"
sh "${file_helper}/create_directory_if_necessary.sh" "${dest}/plugins"
