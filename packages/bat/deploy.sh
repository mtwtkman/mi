here="$(dirname ${BASH_SOURCE[0]})"
abshere="$(readlink -m ${here})"

dest="${HOME}/.config/bat"
file_helper="${here}/../../module/helper/file"

sh "${file_helper}/create_directory_if_necessary.sh" "${dest}"
sh "${file_helper}/refresh_link.sh" "${abshere}/config" "${dest}/config"
sh "${file_helper}/refresh_link.sh" "${abshere}/themes" "${dest}/themes"

bat cache --build
