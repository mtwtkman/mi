here="$(dirname ${BASH_SOURCE[0]})"

dest="${XDG_CONFIG_HOME}/nvim"

sh "${here}/../module/helper/file/create_directory_if_necessary.sh" "${dest}"
cp -a "${here}/config" "${dest}"
