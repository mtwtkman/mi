source $__mi_setup__module_internal_dir_location/bool.sh
source $__mi_setup__module_internal_dir_location/prompt.sh
source $__mi_setup__module_internal_dir_location/string.sh

function __mi_setup__fetch_osname()
{
  IFS="=" read -ra value <<< $(grep '^NAME' /etc/os-release | tr "[:upper:]" "[:lower:]")
  osname=${value[1]}

  if [ -z "${osname}" ]; then
    __mi_setup__prompt_red "ABORT: Cannot detected OS name"
    exit 1
  fi
  echo -n $osname
}

function __mi_setup__is_archlinux()
{
  osname=$(__mi_setup__fetch_osname)
  __mi_setup__string_includes "${osname}" "arch"
}

function __mi_setup__is_sudo_permitted()
{
  if [ $(__mi_setup__has_command "sudo") = $(__mi_setup__true) ]; then
    echo $(__mi_setup__true)
    return
  fi
  echo $(__mi_setup__false)
}

function __mi_setup__has_command()
{
  name=$1
  if ! command -v "${name}" &> /dev/null; then
    echo $(__mi_setup__false)
    return
  else
    echo $(__mi_setup__true)
  fi
}
