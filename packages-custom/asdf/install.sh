here="$(dirname ${BASH_SOURCE[0]})"

helper="${here}/../../module/helper"

dest="${HOME}/.asdf"

if [ "$(sh ${helper}/host/has_command.sh 'asdf')" = "$(sh ${helper}/bool/false.sh)" ]; then
  git clone https://github.com/asdf-vm/asdf.git "${dest}" --branch master
fi
pushd "${dest}" &> /dev/null
git fetch
git reset --hard origin/master
popd &> /dev/null
