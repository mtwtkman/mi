here="$(dirname ${BASH_SOURCE[0]})"

config_location=$(sh "${here}/../../config/location.sh")

cp -a "${here}/d/" "${config_location}/bat/"

mkdir -p "$(bat --config-dir)/themes"
declare -a themes=("Latte" "Frappe" "Macchiato" "Mocha")
for theme in "${themes[@]}"
do
  curl "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20${theme}.tmTheme" -O --output-dir "$(bat --config-dir)/themes"
done
bat cache --build
