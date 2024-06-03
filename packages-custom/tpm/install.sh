here="$(dirname ${BASH_SOURCE[0]})"

dest="${HOME}/.tmux/plugins/tpm"

if [ -d "${dest}" ]; then
  sh "${here}/../../module/helper/prompt/yellow.sh" "SKIP: tpm has been installed"
  exit 0
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
