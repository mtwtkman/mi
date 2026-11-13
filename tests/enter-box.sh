#!/usr/bin/env bash
set -euo pipefail

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

mkdir -p "$tmp/project/src/nested"
cat > "$tmp/project/box" <<'BOX'
#!/usr/bin/env bash
printf '%s\n' "$1" > "$MI_ENTER_BOX_LOG"
BOX
chmod +x "$tmp/project/box"
printf '[container]\n' > "$tmp/project/boxkit.ini"
export MI_ENTER_BOX_LOG="$tmp/enter-box.log"

(
  cd "$tmp/project/src/nested"
  bash "$repo/packages/myscript/this/enter-box"
)
grep -qx 'e' "$MI_ENTER_BOX_LOG"

rm "$MI_ENTER_BOX_LOG" "$tmp/project/boxkit.ini"
printf '[legacy]\n' > "$tmp/project/distrobox.ini"
output="$(
  cd "$tmp/project/src/nested"
  bash "$repo/packages/myscript/this/enter-box"
)"
[[ "$output" == "box cannot be found" ]]
[[ ! -e "$MI_ENTER_BOX_LOG" ]]

echo 'Mi enter-box regression tests passed.'
