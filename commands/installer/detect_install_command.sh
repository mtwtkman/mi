here="$(dirname ${BASH_SOURCE[0]})"

helper="${here}/../helper"
prompt="${helper}/prompt"
is_included="${helper}/string/is_included.sh"
true=$(sh "${helper}/bool/true.sh")
osname="$(sh "${helper}/host/fetch_osname.sh")"

if [ $(sh "${is_included}" "${osname}" "arch") = "${true}" ]; then
  sh "${helper}/distro/arch/update_package.sh"
else
  sh "${prompt}/red.sh" "ABORT: unknown"
  exit 1
fi
