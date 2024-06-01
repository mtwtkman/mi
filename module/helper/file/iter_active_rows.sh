here="$(dirname ${BASH_SOURCE[0]})"

src="${1}"
execution_sh="${2}"

IFS=$'\n'
for row in $(sh "${here}/iter_row.sh" "${src}")
do
  if [ $(sh "${here}/skip_commentout_row.sh" "${row}") = $(sh "${here}/../bool/false.sh") ]; then
    sh "${execution_sh}" "${row}"
  fi
done
