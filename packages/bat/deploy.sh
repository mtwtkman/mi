here="$(dirname ${BASH_SOURCE[0]})"

dest="${XDG_CONFIG_HOME}/bat"

sh "${here}/../../module/helper/file/create_directory_if_necessary.sh" "${dest}"

cp "${here}/config" "${dest}/config"

mkdir -p "$(bat --config-dir)/themes"
declare -a themes=("Latte" "Frappe" "Macchiato" "Mocha")
for theme in "${themes[@]}"
do
  curl "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20${theme}.tmTheme" -o "Catppuccin ${theme}.tmTheme" --output-dir "$(bat --config-dir)/themes"
done
bat cache --build
