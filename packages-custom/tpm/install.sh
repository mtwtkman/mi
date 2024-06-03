here="$(dirname ${BASH_SOURCE[0]})"

dest="${HOME}/.config/tmux/plugins/tpm"

if [ ! -d "${dest}" ]; then
  git clone https://github.com/tmux-plugins/tpm "${dest}"
  exit 0
fi

pushd "${dest}" 1> /dev/null
git fetch
git reset --hard origin/HEAD
popd 1> /dev/null
