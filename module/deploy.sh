here="$(dirname ${BASH_SOURCE[0]})"

prompt="${here}/../module/helper/prompt/"

declare -a packages="$(ls ${here}/../packages)"

for package in "${packages[0]}"
do
  deploy_sh="${here}/../packages/${package}/deploy.sh"
  if [ -f "${deploy_sh}" ]; then
    sh "${prompt}/blue.sh" "DEPLOY: ${package}"
    sh "${deploy_sh}"
    sh "${prompt}/blue.sh" "DEPLOIED: ${package}"
  fi
done
