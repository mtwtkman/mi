here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

source "${here}/message.sh"

src=$1
dest=$2
if [ -L "${dest}" ]; then
  unlink "${dest}"
fi
if [ -e "${dest}" ]; then
  backup="${dest}.mi.bk"
  mv "${dest}" "${backup}"
  yellow "Create backup file for ${dest} as ${backup}"
fi
ln -s "${src}" "${dest}"
