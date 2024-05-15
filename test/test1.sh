function fun()
{
  x=$1
  y=$2
  if [ $x == $y ]; then
    echo "t"
  else
    echo "f"
  fi
}

function spec()
{
  if [ $(fun 1 1) == "t" ]; then
    echo 'ok'
    exit 0
  else
    echo 'failed'
    exit 1
  fi
}

spec
