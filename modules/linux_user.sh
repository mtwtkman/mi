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
if [[ -z "${XDG_RUNTIME_DIR:-}" || ! -d "${XDG_RUNTIME_DIR:-/nonexistent}" ]] || ! command -v systemctl >/dev/null 2>&1; then
  printf "No systemd user session detected; SSH agent activation skipped.\n"
  exit 0
fi
if ! systemctl --user show-environment >/dev/null 2>&1; then
  printf "No active systemd user manager; SSH agent activation skipped.\n"
  exit 0
fi
systemctl --user daemon-reload
systemctl --user enable --now ssh-agent.service
if [[ -n "${SSH_AUTH_SOCK:-}" && "$SSH_AUTH_SOCK" != "${XDG_RUNTIME_DIR}/ssh-agent.sock" ]]; then
  printf "Another SSH agent is in use at %s; it was not stopped. New shells should use %s/ssh-agent.sock.\n" "$SSH_AUTH_SOCK" "$XDG_RUNTIME_DIR" >&2
fi
printf "SSH agent service enabled and started.\n"
printf "Export SSH_AUTH_SOCK=\${XDG_RUNTIME_DIR}/ssh-agent.sock in the host login environment.\n"
