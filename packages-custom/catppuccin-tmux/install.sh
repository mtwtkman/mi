here="$(dirname ${BASH_SOURCE[0]})"

dest="${XDG_CONFIG_HOME}/tmux/plugins/catppuccin"

if [ ! -d ${dest} ]; then
  git clone https://github.om/catppuccin/tmux "${dest}"
fi

pushd "${dest}" &> /dev/null
git fetch
git reset --hard origin/HEAD
popd &> /dev/null
