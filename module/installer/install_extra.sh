here="$(dirname ${BASH_SOURCE[0]})"

case "$(sh ${here}/../helper/host/fetch_osname.sh)" in
  *arch*) sh "${here}/../distro/arch/install_aur.sh";;
  *)
    sh "${here}/../helper/prompt/red.sh" "ABORT: cannot detect osname."
    exit 1
    ;;
esac
