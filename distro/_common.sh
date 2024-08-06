asdf_dir="${HOME}/.asdf"
tmux_plugins_dir="${HOME}/.config/tmux/plugins"

load_asdf()
{
  if [ ! -d asdf_dir ]; then
    git clone https://github.com/asdf-vm/asdf.git "${asdf_dir}" --branch master
  fi
  pushd "${asdf_dir}" &> /dev/null
  git fetch
  git reset --hard origin/master
  popd &> /dev/null
}

load_catppuccin_tmux()
{
  dest="${tmux_plugins_dir}/catppuccin"
  if [ ! -d ${dest} ]; then
    mkdir -p "${dest}"
    git clone https://github.com/catppuccin/tmux "${dest}"
  fi

  pushd "${dest}" &> /dev/null
  git fetch
  git reset --hard origin/HEAD
  popd &> /dev/null
}

depends_on_asdf()
{
  if [ ! -d "${asdf_dir}" ]; then
    load_asdf
  fi
  source "${asdf_dir}/asdf.sh"
}

install_python3()
{
  depends_on_asdf
  asdf plugin add python
  asdf install python latest
  asdf global python latest
}

depends_on_python3()
{
  if ! command -v "python" &> /dev/null; then
    install_python3
  fi
}

install_neovim_remote()
{
  depends_on_python3
  pip3 install neovim-remote
  asdf reshim python
}

upgrade_pip()
{
  depends_on_python3
  pip install --upgrade pip
}


