here="$(dirname ${BASH_SOURCE[0]})"

pacman_command="${here}/pacman.sh"
echo "yes | $(sh ${pacman_command}) -Sy"
