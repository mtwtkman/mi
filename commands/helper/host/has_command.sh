here="$(dirname ${BASH_SOURCE[0]})"

true=$(sh "${here}/../bool/true.sh")
false=$(sh "${here}/../bool/false.sh")
name="${1}"

if ! command -v "${name}" &> /dev/null; then
  echo ${false}
else
  echo ${true}
fi
