__mi_setup__module_internal_dir_location=./$(dirname -- "${BASH_SOURCE[0]}")
source "${__mi_setup__module_internal_dir_location}/bool.sh"

function __mi_setup__string_includes()
{
  value=$1
  ptn=$2
  if [[ "${value}" == *"${ptn}"* ]]; then
    echo $(__mi_setup__true)
  else
    echo $(__mi_setup__false)
  fi
}

unset here
