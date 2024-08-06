here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

source "${here}/message.sh"

target=$1
pushd "${here}/../packages/${target}" &> /dev/null
dest="$(sh ./location)"

create_link()
{
  sh "${here}/make_link.sh" "${1}" "${2}"
  green "Created symlink of "${1}" to "${2}""
}

if [ -d "files" ]; then
  find ./files -maxdepth 1 -mindepth 1 -print0 | while IFS= read -r -d '' f
  do
    src="$(readlink -m ${f})"
    create_link "${src}" "${dest}/$(basename ${src})"
  done
elif [ -d "this" ]; then
  create_link $(readlink -m "this") "${dest}"
else
  red "Cannot find config files."
  exit 1
fi
popd &> /dev/null
