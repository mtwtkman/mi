abshere="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"
prompt="${abshere}//helper/prompt/"

pushd "${abshere}/../packages-custom" 1> /dev/null

for package in *
do
  sh "${prompt}/blue.sh" "INSTALL: ${package}"
  sh "${package}/install.sh"
  sh "${prompt}/green.sh" "INSTALLED: ${package}"
done

popd 1> /dev/null
