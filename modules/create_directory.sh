#!/bin/bash
dest=$1
if [ -d "${dest}" ]; then
  exit 0
fi
mkdir -p "${dest}"
