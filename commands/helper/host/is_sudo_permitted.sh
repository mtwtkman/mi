here="$(dirname ${BASH_SOURCE[0]})"

true=$(sh "${here}/../bool/true.sh")
false=$(sh "${here}/../bool/false.sh")

if [ $(sh "${here}/has_command.sh" "sudo") = "${true}" ]; then
  echo "${true}"
else
  echo "${false}"
fi
