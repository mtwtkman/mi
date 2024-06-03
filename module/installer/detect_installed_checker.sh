here="$(dirname ${BASH_SOURCE[0]})"

case "$(sh ${here}/../helper/host/fetch_osname.sh)" in
  *arch*) echo "${here}/../distro/arch/check_installed.sh";;
  *ubuntu*) echo "${here}/../distro/ubuntu/check_installed.sh";;
  *)
    sh "${prompt}/red.sh" "ABORT: unknown"
    exit 1;;
esac
