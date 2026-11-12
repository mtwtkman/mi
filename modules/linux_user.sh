#!/usr/bin/env bash
set -euo pipefail
[[ "$(uname -s)" == Linux && "${MI_PROFILE:-host}" != container ]] || exit 0
unit_dir="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
unit="$unit_dir/ssh-agent.service"
source_unit="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)/systemd/user/ssh-agent.service"
mkdir -p -- "$unit_dir"
if [[ -e "$unit" || -L "$unit" ]]; then
  if ! cmp -s -- "$unit" "$source_unit"; then
    printf "Existing SSH agent unit differs: %s (left unchanged)\n" "$unit" >&2
    exit 1
  fi
else
  cp -- "$source_unit" "$unit"
fi
printf "SSH agent unit installed: %s\n" "$unit"
printf "Activate: systemctl --user daemon-reload && systemctl --user enable --now ssh-agent.service\n"
printf "Export SSH_AUTH_SOCK=\${XDG_RUNTIME_DIR}/ssh-agent.sock in the host login environment.\n"
