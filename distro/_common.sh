load_asdf()
{
  dest="${HOME}/.asdf"
  if [ ! -d dest ]; then
    git clone https://github.com/asdf-vm/asdf.git "${dest}" --branch master
  fi
  pushd "${dest}" &> /dev/null
  git fetch
  git reset --hard origin/master
  popd &> /dev/null
}

load_catppuccin_tmux()
{
  dest="${XDG_CONFIG_HOME}/tmux/plugins/catppuccin"

  if [ ! -d ${dest} ]; then
    git clone https://github.com/catppuccin/tmux "${dest}"
  fi

  pushd "${dest}" &> /dev/null
  git fetch
  git reset --hard origin/HEAD
  popd &> /dev/null
}

install_python3()
{
  asdf plugin add python
  asdf install python latest
  asdf global python latest
}

install_neovim_remote()
{
  pip3 install neovim-remote
  asdf reshim python
}

upgrade_pip()
{
  pip install --upgrade pip
}


