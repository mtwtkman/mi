abshere="$(readlink -m $(dirname ${BASH_SOURCE[0]}))"

pushd "${abshere}/../packages-custom" 1> /dev/null

prompt="${here}//helper/prompt/"

for package in *
do
  deploy_sh="${package}/deploy.sh"
  if [ -f "${deploy_sh}" ]; then
    sh "${prompt}/blue.sh" "DEPLOY: ${package}"
    sh "${deploy_sh}"
    sh "${prompt}/blue.sh" "DEPLOIED: ${package}"
  fi
done

popd 1> /dev/null
