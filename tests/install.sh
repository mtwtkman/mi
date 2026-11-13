#!/usr/bin/env bash
set -euo pipefail

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT
mkdir -p "$tmp/bin" "$tmp/home"
export HOME="$tmp/home"
# Keep deployment confined to the temporary HOME; do not manage host user services.
export MI_PROFILE=container
export MI_TEST_LOG="$tmp/commands.log"

cat > "$tmp/bin/sudo" <<'MOCK'
#!/usr/bin/env bash
printf 'sudo %s\n' "$*" >> "$MI_TEST_LOG"
[[ "${MI_FAIL_APT:-}" != 1 ]]
MOCK
cat > "$tmp/bin/brew" <<'MOCK'
#!/usr/bin/env bash
printf 'brew %s\n' "$*" >> "$MI_TEST_LOG"
[[ "${MI_FAIL_BREW:-}" != 1 ]]
MOCK
chmod +x "$tmp/bin/sudo" "$tmp/bin/brew"
export PATH="$tmp/bin:$PATH"

# Stub package management without ever modifying the CI runner.
bash "$repo/distro/debian.sh" install >/dev/null
grep -qx 'sudo apt update' "$MI_TEST_LOG"
grep -qx 'sudo apt upgrade -y' "$MI_TEST_LOG"
grep -qx 'sudo apt install -y git build-essential' "$MI_TEST_LOG"
grep -q '^brew install bash bat podman ' "$MI_TEST_LOG"

# Package manager errors must stop deployment and propagate to the CLI.
: > "$MI_TEST_LOG"
if MI_FAIL_APT=1 bash "$repo/distro/debian.sh" install >/dev/null; then
  echo 'FAIL: apt failure was ignored' >&2
  exit 1
fi
! grep -q '^brew ' "$MI_TEST_LOG"

: > "$MI_TEST_LOG"
if MI_FAIL_BREW=1 bash "$repo/distro/debian.sh" install >/dev/null; then
  echo 'FAIL: brew failure was ignored' >&2
  exit 1
fi

# Arch install must install only Mi's selected packages, not update unrelated AUR
# packages (such as a locally installed, currently unbuildable howdy-git).
cat > "$tmp/bin/paru" <<'MOCK'
#!/usr/bin/env bash
printf 'paru %s\n' "$*" >> "$MI_TEST_LOG"
MOCK
cat > "$tmp/bin/checkrebuild" <<'MOCK'
#!/usr/bin/env bash
printf 'checkrebuild %s\n' "$*" >> "$MI_TEST_LOG"
MOCK
chmod +x "$tmp/bin/paru" "$tmp/bin/checkrebuild"
: > "$MI_TEST_LOG"
bash "$repo/distro/arch.sh" install >/dev/null
grep -q '^paru -S --needed --noconfirm bash bash-completion ' "$MI_TEST_LOG"
! grep -q '^paru -Syu' "$MI_TEST_LOG"
! grep -q 'howdy-git' "$MI_TEST_LOG"

# Update retains an explicit, system-wide upgrade and rebuild check.
: > "$MI_TEST_LOG"
bash "$repo/distro/arch.sh" update >/dev/null
grep -qx 'paru -Syu --noconfirm' "$MI_TEST_LOG"
grep -qx 'checkrebuild ' "$MI_TEST_LOG"

# setup must preserve the failing mi exit status, not return its final echo status.
cat > "$tmp/bin/git" <<'MOCK'
#!/usr/bin/env bash
if [[ "${1:-}" == clone ]]; then
  mkdir -p "$HOME/.local/mi"
  cat > "$HOME/.local/mi/mi" <<'SCRIPT'
#!/usr/bin/env bash
exit 42
SCRIPT
  chmod +x "$HOME/.local/mi/mi"
else
  exit 1
fi
MOCK
chmod +x "$tmp/bin/git"
set +e
bash "$repo/setup" >/dev/null
status=$?
set -e
[[ "$status" -eq 42 ]] || { echo "FAIL: setup returned $status instead of 42" >&2; exit 1; }

echo 'All Mi installer regression tests passed.'
