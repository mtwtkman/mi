__mi_setup__module_package_internal_fs=./$(dirname -- "${BASH_SOURCE[0]}")

function __mi_setup__copy_package_config()
{
  src=$1
  dest=$2
  cp -a "${__mi_setup__module_package_internal_fs}/../${src}" "${dest}"
}

function __mi_setup__copy_package_config_dir()
{
  package=$1
  __mi_setup__copy_package_config "${pckage}/d" "$(__mi_setup__config_dir)/${package}"
}

function __mi_setup__copy_package_config_file()
{
  package=$1
  filename=$2
  __mi_setup__copy_package_config "${package}/${filename}" "${HOME}/${filename}"
}

function __mi_setup__listup_package_filename()
{
  for entry in "$(__mi_setup__module_pcakge_internal_fs)/../"
}

unset __mi_setup__module_package_internal_fs
