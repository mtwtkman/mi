__mi_setup__config_dir_location=./$(dirname -- "${BASH_SOURCE[0]}")/../config

function __mi_setup__config()
{
  config_path="$HOME/.config"
  if [ ! -d "${config_path}" ]; then
    mkdir "${config_path}"
  fi

  cp -i -a "${__mi_setup__config_dir_location}/*" $HOME
}

unset __mi_setup__config_dir_location
