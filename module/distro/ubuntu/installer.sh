here="$(dirname ${BASH_SOURCE[0]})"

apt_command="${here}/apt.sh"
echo "$(sh ${apt_command}) install -y"
