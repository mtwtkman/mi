here="$(dirname ${BASH_SOURCE[0]})"

config_location=$(sh "${here}/../../config/location.sh")

cp -a "${here}/d/" "${config_location}/git/"
