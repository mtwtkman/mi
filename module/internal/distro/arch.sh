source $__mi_setup__module_internal_dir

function __mi_setup__distro_arch_install_command()
{
  if [ $(__mi_setup__is_sudo_permitted) = $(__mi_setup__true) ]; then
    echo "yes | sudo pacman -Sy"
  else
    echo "yes | pacman -Sy"
  fi
}
