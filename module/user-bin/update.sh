here="$(dirname ${BASH_SOURCE[0]})"

distro_dir="${here}/../distro"

case "$(sh ${here}/../helper/host/fetch_osname.sh)" in
  *arch*) cp "$(sh ${distro_dir}/arch/update.sh)" /usr/local/bin;;
  *ubuntu*) cp "$(sh ${distro_dir}/ubuntu/update.sh)" /usr/local/bin;;
esac
