here="$(dirname ${BASH_SOURCE[0]})"

txt="${1}"

if [[ "${txt}" == \#* ]]; then
  sh "${here}/../bool/true.sh"
else
  sh "${here}/../bool/false.sh"
fi
