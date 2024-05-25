here="$(dirname ${BASH_SOURCE[0]})"
if [ "$(sh ${here}/../../host/is_sudo_permitted.sh)" = "$(sh ${here}/../../bool/true.sh)" ]; then
  echo "sudo pacman"
else
  echo "pacman"
fi
