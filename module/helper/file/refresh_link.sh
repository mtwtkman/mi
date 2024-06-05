here="$(dirname ${BASH_SOURCE[0]})"

src="${1}"
dest="${2}"

if [ -L "${dest}" ]; then
  unlink "${dest}"
fi

ln -s "${src}" "${dest}"
