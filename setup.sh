#!/bin/sh

here=./$(dirname -- "${BASH_SOURCE[0]}")
packages_def="${here}/packages"
source $here/module/main.sh

function __mi_setup__config()
{
  echo 'todo'
}

function __mi_setup__execute()
{
  __mi_setup__iter_install "${1}"
  __mi_setup__config
}

__mi_setup__execute "${packages_def}"

unset here
