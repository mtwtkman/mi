here="$(dirname -- ${BASH_SOURCE[0]})"
value=$1
ptn=$2
if [[ "${value}" == *"${ptn}"* ]]; then
  echo "$(sh ${here}/../bool/true.sh)"
else
  echo "$(sh ${here}/../bool/false.sh)"
fi
