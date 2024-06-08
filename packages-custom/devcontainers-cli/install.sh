here="$(dirname ${BASH_SOURCE[0]})"
helper="${here}/../../module/helper"

if [ "$(sh ${helper}/host/has_command.sh 'npm')" = "$(sh ${helper}/bool/false.sh)"]; then
  asdf plugin add nodejs
  asdf install nodejs latest
  asdf global nodejs latest
fi

npm install -g @devcontainers/cli
asdf reshim nodejs
