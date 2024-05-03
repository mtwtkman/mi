__mi_setup__module_package_bash=./$(dirname -- "${BASH_SOURCE[0]}")

function __mi_setup__module_package_bash()
{
  cp $__mi_setup__module_package_bash/.bashrc $HOME/.bashrc
}
unset __mi_setup__module_package_bash
