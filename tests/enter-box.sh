#!/usr/bin/env bash
set -euo pipefail

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

mkdir -p "$tmp/project/src/nested"
cat > "$tmp/project/box" <<'BOX'
#!/usr/bin/env bash
printf '%s\n' "$@" > "$MI_ENTER_BOX_LOG"
printf '%s\n' "$PWD" > "$MI_ENTER_BOX_PWD_LOG"
case "${MI_ENTER_BOX_MODE:-success}" in
  success) ;;
  recreate)
    for arg in "$@"; do
      [[ "$arg" == -r ]] && exit 0
    done
    printf '%s\n' "boxkit: container configuration or socket path changed; run './box enter -r' to recreate (HOME preserved)" >&2
    exit 1
    ;;
  stale)
    printf '%s\n' "boxkit: host socket inode changed while container is running; use './box stop' then './box enter'" >&2
    exit 1
    ;;
  other)
    printf '%s\n' "boxkit: unrelated error" >&2
    exit 17
    ;;
esac
BOX
chmod +x "$tmp/project/box"
printf '[container]\n' > "$tmp/project/boxkit.ini"
export MI_ENTER_BOX_LOG="$tmp/enter-box.log"
export MI_ENTER_BOX_PWD_LOG="$tmp/enter-box-pwd.log"

(
  cd "$tmp/project/src/nested"
  bash "$repo/packages/myscript/this/enter-box"
)
grep -qx 'e' "$MI_ENTER_BOX_LOG"
grep -qx -- '--workdir' "$MI_ENTER_BOX_LOG"
grep -qx '/workspace/src/nested' "$MI_ENTER_BOX_LOG"
(
  cd "$tmp/project"
  bash "$repo/packages/myscript/this/enter-box"
)
grep -qx '/workspace' "$MI_ENTER_BOX_LOG"


# A recreation requirement must not automatically remove a container without
# interactive approval. An unrelated failure must not prompt either.
export MI_ENTER_BOX_MODE=recreate
if (
  cd "$tmp/project/src/nested"
  bash "$repo/packages/myscript/this/enter-box" </dev/null 2>"$tmp/no-tty.err"
); then
  echo 'unexpected noninteractive recreation' >&2
  exit 1
fi
grep -Fq 'confirmation requires a terminal' "$tmp/no-tty.err"
! grep -qx -- '-r' "$MI_ENTER_BOX_LOG"

export MI_ENTER_BOX_MODE=other
if (
  cd "$tmp/project/src/nested"
  bash "$repo/packages/myscript/this/enter-box" </dev/null 2>"$tmp/other.err"
); then
  echo 'unexpected success for unrelated failure' >&2
  exit 1
else
  [[ "$?" -eq 17 ]]
fi
grep -Fq 'unrelated error' "$tmp/other.err"

# 'script' allocates a controlling TTY to exercise both confirmation paths.
if command -v script >/dev/null 2>&1; then
  export MI_ENTER_BOX_MODE=recreate
  printf 'n\n' | script -q -e -c "cd '$tmp/project/src/nested' && bash '$repo/packages/myscript/this/enter-box'" "$tmp/decline.log" >/dev/null || :
  ! grep -qx -- '-r' "$MI_ENTER_BOX_LOG"

  printf 'y\n' | script -q -e -c "cd '$tmp/project/src/nested' && bash '$repo/packages/myscript/this/enter-box'" "$tmp/accept.log" >/dev/null
  grep -qx -- '-r' "$MI_ENTER_BOX_LOG"
  grep -qx -- '/workspace/src/nested' "$MI_ENTER_BOX_LOG"
  [[ "$(cat "$MI_ENTER_BOX_PWD_LOG")" == "$tmp/project" ]]
fi
unset MI_ENTER_BOX_MODE

rm "$MI_ENTER_BOX_LOG" "$tmp/project/boxkit.ini"
output="$(
  cd "$tmp/project/src/nested"
  bash "$repo/packages/myscript/this/enter-box"
)"
[[ "$output" == "box cannot be found" ]]
[[ ! -e "$MI_ENTER_BOX_LOG" ]]

echo 'Mi enter-box regression tests passed.'
