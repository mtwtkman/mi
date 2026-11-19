#!/bin/bash
here="$(eval "${MI_ABSPATH_GETTER} $(dirname ${BASH_SOURCE[0]})")"

source "${here}/message.sh"

processed=0

our_dir=(
  "${HOME}/.config"
  "${HOME}/.local/bin"
)

for d in "${our_dir[@]}"
do
  if [ ! -d "${d}" ]; then
    processed=$((processed+1))
    if [ $processed = 1 ]; then
      blue "Prepare some directories"
    fi
    mkdir -p "${d}"
    green "Created ${d}"
  fi
done
