here="$(dirname ${BASH_SOURCE[0]})"
module="${here}/../../module"
helper="${module}/helper"
install_="${module}/installer/install.sh"
prompt="${helper}/prompt"
bool="${helper}/bool"

sh "${prompt}/blue.sh" "install dependencies for docker root less mode"
case $(sh "${helper}/host/fetch_osname.sh") in
  *arch*)
    sh "${install_}" "fuse-overlayfs"
    found="$(sh "${bool}/false.sh")";
    dest="/etc/sysctl.conf"
    for l in $(cat "${dest}")
    do
      if [ $l = "kernel.unprivileged_userns_clone=1" ]; then
        found="$(sh ${bool}/true.sh)"
      fi
    done
    if [ "${found}" = $(sh ${bool}/false.sh) ]; then
      sudo echo "kernel.unprivileged_userns_clone=1" >> "${dest}"
    fi
    sudo sysctl --system
    ;;
  *ubuntu*)
    echo "TBD"
    exit 0
    ;;
esac

sh "${install_}" "docker"

sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $USER

curl -fsSL https://get.docker.com/rootless | FORCE_ROOTLESS_INSTALL=1 sh
