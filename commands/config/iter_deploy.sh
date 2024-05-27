here="$(dirname ${BASH_SOURCE[0]})"

for p in $(sh "${here}/../" "${1}")
do
  sh "${here}/deploy.sh" "${p}"
done
