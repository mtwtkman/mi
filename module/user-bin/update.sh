here="$(dirname ${BASH_SOURCE[0]})"

distro_dir="${here}/../distro"

case "$(sh ${here}/../helper/host/fetch_osname.sh)" in
  *arch*) sudo cp "${distro_dir}/arch/update"  "/usr/local/bin";;
  *ubuntu*) sudo cp "${distro_dir}/ubuntu/update" "/usr/local/bin";;
esac
