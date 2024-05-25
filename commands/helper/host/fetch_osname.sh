here="$(dirname ${BASH_SOURCE[0]})"
IFS="=" read -ra value <<< $(grep '^NAME' /etc/os-release | tr "[:upper:]" "[:lower:]")
osname="${value[1]}"
if [ -z "${osname}" ]; then
  sh "${here}/../prompt/red.sh" "ABORT: Cannot detected OS name"
  exit 1
fi
echo "${osname}"
