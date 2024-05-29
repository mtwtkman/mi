here="$(dirname ${BASH_SOURCE[0]})"

case "$(sh ${here}/../helper/host/fetch_osname.sh)" in
  *arch*) sh "${here}/../distro/arch/update_package.sh";;
  *ubuntu*) sh "${here}/../distro/ubuntu/update_package.sh";;
  *)
    sh "${prompt}/red.sh" "ABORT: unknown"
    exit 1;;
esac
