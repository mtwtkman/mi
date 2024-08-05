here="$(dirname ${BASH_SOURCE[0]})"

target=$1
pushd "${here}/../packages/${target}" &> /dev/null
dest="$(sh ./location)"
sh "${here}/prepare_directory.sh" "${dest}"
for f in * .*
do
  if [ "${f}" = "location" ]; then
    continue;
  fi
  sh "${here}/make_link.sh" "$(readlink -m ${f})" "${dest}"
done
popd &> /dev/null
