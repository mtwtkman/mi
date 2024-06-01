here="$(dirname ${BASH_SOURCE[0]})"

if [ $(sh "${here}/has_command.sh" "${1}") = "${here}/../bool/true.sh" ]; then
  exit 0;
else
  sh "${2}"
fi
