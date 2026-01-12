#!/bin/bash
here="$(eval "${MI_ABSPATH_GETTER} $(dirname ${BASH_SOURCE[0]})")"

source "${here}/message.sh"

target=$1
pushd "${here}/../packages/${target}" &> /dev/null
dest="$(bash ./location)"

create_link()
{
  bash "${here}/make_link.sh" "${1}" "${2}"
  green "Created symlink of "${1}" to "${2}""
}

if [ -d "files" ]; then
  find ./files -maxdepth 1 -mindepth 1 -print0 | while IFS= read -r -d '' f
  do
    src="$(eval "${MI_ABSPATH_GETTER} ${f}")"
    create_link "${src}" "${dest}/$(basename ${src})"
  done
elif [ -d "this" ]; then
  [ ! -d "${dest}" ] && mkdir -p "${dest}"
  create_link "${parent}" "${dest}"
else
  red "Cannot find config files."
  exit 1
fi
popd &> /dev/null
