#!/usr/bin/env bash
set -euo pipefail

dest=${1:?Destination path required}
backup="${dest}.mi.bk"

[[ -e "$dest" || -L "$dest" ]] || exit 0

if [[ -e "$backup" || -L "$backup" ]]; then
  if [[ ! -t 0 || ! -t 1 || ! -r /dev/tty ]]; then
    printf 'Backup already exists: %s (interactive choice required)\n' "$backup" >&2
    exit 1
  fi

  printf 'Backup already exists: %s\n' "$backup" >/dev/tty
  printf 'Choose [r]otate old backup, [o]verwrite old backup, [c]ancel (default): ' >/dev/tty
  choice=''
  IFS= read -r choice </dev/tty || exit 1

  case "$choice" in
    r|R)
      n=1
      while [[ -e "${backup}.$n" || -L "${backup}.$n" ]]; do
        ((n+=1))
      done
      mv -- "$backup" "${backup}.$n"
      printf 'Preserved existing backup as %s\n' "${backup}.$n"
      ;;
    o|O)
      rm -rf -- "$backup"
      printf 'Overwriting previous backup: %s\n' "$backup"
      ;;
    *)
      printf 'Cancelled; destination and backup unchanged.\n' >&2
      exit 1
      ;;
  esac
fi

mv -- "$dest" "$backup"
printf 'Created backup for %s as %s\n' "$dest" "$backup"
