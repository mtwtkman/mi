here="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

source "${here}/message.sh"

target=$1
pushd "${here}/../packages/${target}" &> /dev/null
dest="$(sh ./location)"
sh "${here}/prepare_directory.sh" "${dest}"
for f in * .*
do
  if [ "${f}" = "location" ]; then
    continue;
  fi
  src="$(readlink -m ${f})"
  sh "${here}/make_link.sh" "${src}" "${dest}"
  green "Created symlink of "${src}" to "${dest}""
done
popd &> /dev/null
