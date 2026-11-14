#!/usr/bin/env bash
set -euo pipefail

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

# Help must work before environment initialization or distribution detection.
for flag in '' --help -h help; do
  HOME="$tmp/nonexistent-home" DISTRO=unsupported MI_PROFILE=container \
    bash "$repo/mi" ${flag:+"$flag"} > "$tmp/help"
  grep -Fq 'Usage: mi [command] [--help]' "$tmp/help"
  grep -Fq 'MI_PACKAGES' "$tmp/help"
  grep -Fq 'MI_PROFILE' "$tmp/help"
  grep -Fq 'MI_DEPLOY_MODE' "$tmp/help"
  grep -Fq 'XDG_CONFIG_HOME' "$tmp/help"
  grep -Fq 'HOME' "$tmp/help"
  grep -Fq 'DISTRO' "$tmp/help"
  grep -Fq 'mi sweep' "$tmp/help"
  grep -Fq 'box-midep neovim,git' "$tmp/help"
  [[ ! -e "$tmp/nonexistent-home" ]] || {
    echo 'FAIL: help created a HOME directory' >&2
    exit 1
  }
done

# All aliases must render the same reference.
bash "$repo/mi" --help > "$tmp/long"
bash "$repo/mi" -h > "$tmp/short"
bash "$repo/mi" help > "$tmp/word"
cmp "$tmp/long" "$tmp/short"
cmp "$tmp/long" "$tmp/word"
bash "$repo/mi" > "$tmp/empty"
cmp "$tmp/long" "$tmp/empty"

# Command help works in an unsupported environment without initialization.
for cmd in deploy install update purge sweep; do
  for flag in --help -h; do
    HOME="$tmp/nonexistent-home" DISTRO=unsupported MI_PROFILE=container \
      bash "$repo/mi" "$cmd" "$flag" > "$tmp/$cmd.help"
    grep -Fq "Usage: mi $cmd" "$tmp/$cmd.help"
    [[ ! -e "$tmp/nonexistent-home" ]] || {
      echo "FAIL: $cmd help created a HOME directory" >&2
      exit 1
    }
  done
done
grep -Fq -- '--force' "$tmp/sweep.help"
grep -Fq -- '--force' "$tmp/long"
grep -Fq 'MI_PACKAGES' "$tmp/deploy.help"
grep -Fq 'MI_PACKAGES' "$tmp/sweep.help"

echo 'Mi help regression tests passed.'
