here="$(dirname ${BASH_SOURCE[0]})"

prepare_command="$(sh "${here}/../installer.sh") --needed git base-devel"

pushd ${HOME}
eval "${prepare_command}"
git clone --depth 1 https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
popd
