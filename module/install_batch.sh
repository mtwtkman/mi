abshere="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

pushd "${abshere}/../packages" 1> /dev/null

for package in *
do
  sh "${abshere}/installer/install.sh" "${package}"
done

popd 1> /dev/null
