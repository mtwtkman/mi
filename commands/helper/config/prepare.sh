here="$(dirname ${BASH_SOURCE[0]})"
config_path=$(sh "${here}/location.sh")
if [ ! -d "${config_path}" ]; then
  mkdir "${config_path}"
fi
