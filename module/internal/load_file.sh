function __mi_setup__iter_read()
{
  while read line; do
    echo $line
  done < "${1}"
}
