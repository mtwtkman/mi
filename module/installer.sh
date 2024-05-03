source $__me_setup__module_dir_location/internal/main.sh

function __mi_setup__detect_install_command()
{
  if [ $(__mi_setup__is_archlinux) = $(__mi_setup__true) ]; then
    if [ $(__mi_setup__is_sudo_permitted) = $(__mi_setup__true) ]; then
      echo "yes | sudo pacman -Sy"
    else
      echo "yes | pacman -Sy"
    fi
  fi
}

function __mi_setup__do_install()
{
  package_name=$1
  eval "$(__mi_setup__detect_install_command) ${package_name}"
}

function __mi_setup__install()
{
  package_name=$1

  if [ $(__mi_setup__has_command $package_name) = $(__mi_setup__true) ]; then
    __mi_setup__prompt_green "SKIP: ${pakcage_name} has been installed"
    return
  fi
  __mi_setup__prompt_blue "INSTALL: ${package_name}"
  __mi_setup__do_install "${package_name}"
  __mi_setup__prompt_green "INSTALLED: ${package_name}"
}

function __mi_setup__iter_install()
{
  for p in $(__mi_setup__iter_read "${1}")
  do
    __mi_setup__install "${p}"
  done
}

function __mi_setup__do_install_extra()
{
  package_name=$1
  installer="__mi_setup__install_extra_${package_name}"
  eval "$(${installer})"
}
