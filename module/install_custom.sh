abshere="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

pushd "${abshere}/../packages-custom" 1> /dev/null

for package in *
do
  sh "${package}/install.sh"
done

popd 1> /dev/null
