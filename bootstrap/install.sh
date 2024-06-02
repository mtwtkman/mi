here="$(dirname ${BASH_SOURCE[0]})"

declare -a packages="$(ls ${here}/../packages)"

for package in "${packages[0]}"
do
  sh "${here}/../module/installer/install.sh" "${package}"
done
