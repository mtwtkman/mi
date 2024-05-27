here="$(dirname ${BASH_SOURCE[0]})"

for p in $(sh "${here}/../helper/file/iter_read.sh" "${1}")
do
  sh "${here}/install.sh" "${p}"
done
