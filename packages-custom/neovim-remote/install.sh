here="$(dirname ${BASH_SOURCE[0]})"
helper="${here}/../../module/helper"

if [ "$(sh ${helper}/host/has_command.sh 'pip3')" = "$(sh ${helper}/bool/false.sh)"]; then
  asdf plugin add python
  asdf install python latest
  asdf global python latest
fi

pip3 install neovim-remote
asdf reshim python
