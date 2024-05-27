here="$(dirname ${BASH_SOURCE[0]})"

echo "yes | $(sh ${here}/pacman.sh) -Sy"
