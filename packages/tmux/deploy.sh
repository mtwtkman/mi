here="$(dirname ${BASH_SOURCE[0]})"

dest="${XDG_CONFIG_HOME}/tmux"

sh "${here}/../../module/helper/file/create_directory_if_necessary.sh" "${dest}"
cp "${here}/tmux.conf" "${dest}"
