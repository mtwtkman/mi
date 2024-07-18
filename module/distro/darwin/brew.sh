here="$(dirname ${BASH_SOURCE[0]})"

helper="${here}/../../helper"
prompt="${helper}/prompt"

if [ "$(sh ${helper}/host/has_command.sh 'brew')" = "$(sh ${helper}/bool/false.sh)" ]; then
  sh "${prompt}/blue.sh" "INSTALL: brew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  sh "${prompt}/green.sh" "INSTALLED: brew"
fi

if [ "$(sh ${here}/../../helper/host/is_sudo_permitted.sh)" = "$(sh ${here}/../../helper/bool/true.sh)" ]; then
  echo "sudo brew"
else
  echo "brew"
fi
