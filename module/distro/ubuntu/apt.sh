here="$(dirname ${BASH_SOURCE[0]})"

if [ "$(sh ${here}/../../helper/host/is_sudo_permitted.sh)" = "$(sh ${here}/../../helper/bool/true.sh)" ]; then
  echo "sudo apt"
else
  echo "apt"
fi
