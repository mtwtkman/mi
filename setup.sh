#! /bin/sh

RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
CLEAR="\033[0m"

TRUE="T"
FALSE="F"

function __mi_setup__prompt_decorate()
{
  echo -e "$@${CLEAR}"
}
function __mi_setup__prompt_red()
{
  __mi_setup__prompt_decorate "${RED}$@"
}
function __mi_setup__prompt_green()
{
  __mi_setup__prompt_decorate "${GREEN}$@"
}
function __mi_setup__prompt_blue()
{
  __mi_setup__prompt_decorate "${BLUE}$@"
}

function __mi_setup__string_includes()
{
  value=$1
  ptn=$2
  if [[ "${value}" == *"${ptn}"* ]]; then
    echo $TRUE
  else
    echo $FALSE
  fi

}

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
  if [ $(__mi_setup__has_command "sudo") = $TRUE ]; then
    echo $TRUE
    return
  fi
  echo $FALSE
}


function __mi_setup__detect_install_command()
{
  if [ $(__mi_setup__is_archlinux) = $TRUE ]; then
    if [ $(__mi_setup__is_sudo_permitted) = $TRUE ]; then
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

function __mi_setup__has_command()
{
  name=$1
  if ! command -v "${name}" &> /dev/null; then
    echo $FALSE
    return
  else
    echo $TRUE
  fi
}

function __mi_setup__install()
{
  package_name=$1

  if [ $(__mi_setup__has_command $package_name) = $TRUE ]; then
    __mi_setup__prompt_green "SKIP: ${pakcage_name} has been installed"
    return
  fi
  __mi_setup__prompt_blue "INSTALL: ${package_name}"
  __mi_setup__do_install "${package_name}"
  __mi_setup__prompt_green "INSTALLED: ${package_name}"
}

__mi_setup__install "git"
__mi_setup__install "neovim"
__mi_setup__install "tree-sitter"
__mi_setup__install "ripgrep"
__mi_setup__install "fd"
__mi_setup__install "gcc"
__mi_setup__install "bat"
__mi_setup__install "fzf"
__mi_setup__install "direnv"
__mi_setup__install "asdf"
__mi_setup__install "jaq"
__mi_setup__install "docker"
__mi_setup__install "tmux"
__mi_setup__install "lua-language-server"
