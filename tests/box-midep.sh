#!/usr/bin/env bash
set -euo pipefail

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

script="$repo/packages/myscript/this/box-midep"
mkdir -p "$tmp/project" "$tmp/bin"
cat > "$tmp/bin/mi" <<'MOCK'
#!/usr/bin/env bash
printf 'HOME=%s\nMI_PACKAGES=%s\nCOMMAND=%s\n' "$HOME" "${MI_PACKAGES:-}" "$*" > "$MI_BOX_MIDEP_LOG"
MOCK
chmod +x "$tmp/bin/mi"
export PATH="$tmp/bin:$PATH"
export MI_BOX_MIDEP_LOG="$tmp/result"

cat > "$tmp/project/boxkit.ini" <<'INI'
# Other settings must not be confused with [container] home
[other]
home = unrelated
[container]
name = demo
home = .boxkit/custom-home
[integration]
home = ignored
INI

check_error() {
  local message="$1"
  shift
  rm -f "$MI_BOX_MIDEP_LOG"
  if "$@" > "$tmp/output" 2>&1; then
    echo "FAIL: expected nonzero exit: $message" >&2
    exit 1
  else
    status=$?
    [[ "$status" -eq 1 ]] || { echo "FAIL: expected status 1, got $status" >&2; exit 1; }
  fi
  grep -Fq "$message" "$tmp/output" || {
    echo "FAIL: missing diagnostic: $message" >&2
    cat "$tmp/output" >&2
    exit 1
  }
  [[ ! -e "$MI_BOX_MIDEP_LOG" ]] || { echo "FAIL: mi was invoked" >&2; exit 1; }
}

(
  cd "$tmp/project"
  check_error 'container HOME directory not found' bash "$script" neovim,git
  mkdir -p .boxkit/custom-home
  bash "$script" neovim,git
)
grep -Fxq "HOME=$tmp/project/.boxkit/custom-home" "$MI_BOX_MIDEP_LOG"
grep -Fxq 'MI_PACKAGES=neovim git' "$MI_BOX_MIDEP_LOG"
grep -Fxq 'COMMAND=deploy' "$MI_BOX_MIDEP_LOG"

(
  cd "$tmp/project"
  check_error 'usage:' bash "$script" 'neovim,,git'
  check_error 'usage:' bash "$script"
  check_error 'usage:' bash "$script" 'neovim,'
  sed -i 's|home = .boxkit/custom-home|home = ../other|' boxkit.ini
  check_error 'container.home must be' bash "$script" neovim
  sed -i '/home = ..\/other/d' boxkit.ini
  check_error 'missing [container] home setting' bash "$script" neovim
  rm boxkit.ini
  check_error 'boxkit.ini not found' bash "$script" neovim
)

echo 'Mi box-midep regression tests passed.'
