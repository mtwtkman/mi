function __mi_setup__prompt_decorate()
{
  local clear="\033[0m"
  echo -e "$@${clear}"
}

function __mi_setup__prompt_red()
{
  local red="\033[0;31m"
  __mi_setup__prompt_decorate "${red}$@"
}

function __mi_setup__prompt_green()
{
  local green="\033[0;32m"
  __mi_setup__prompt_decorate "${green}$@"
}

function __mi_setup__prompt_blue()
{
  local blue="\033[0;34m"
  __mi_setup__prompt_decorate "${blue}$@"
}
