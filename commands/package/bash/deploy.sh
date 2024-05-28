here=$(dirname "${BASH_SOURCE[0]}")

cp "${here}/.bashrc" "${HOME}"
source "${HOME}/.bashrc"
