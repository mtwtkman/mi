#!/usr/bin/env bash
set -euo pipefail

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT
export HOME="$tmp/home"
export XDG_DATA_HOME="$HOME/.local/share"
export MI_BOXKIT_GIT_LOG="$tmp/git-log"
mkdir -p "$HOME" "$tmp/bin"

# Exercise clone/update without contacting GitHub or modifying the runner.
cat > "$tmp/bin/git" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >> "$MI_BOXKIT_GIT_LOG"
case "${1:-}" in
  clone)
    [[ "${2:-}" == --depth && "${3:-}" == 1 ]]
    [[ "${4:-}" == https://github.com/mtwtkman/boxkit.git ]]
    dir="$5"
    mkdir -p "$dir/.git"
    printf '#!/usr/bin/env bash\n' > "$dir/boxkit"
    chmod +x "$dir/boxkit"
    ;;
  -C)
    [[ "${3:-}" == pull && "${4:-}" == --ff-only ]]
    [[ -d "$2/.git" ]]
    ;;
  *) exit 1;;
esac
MOCK
chmod +x "$tmp/bin/git"
export PATH="$tmp/bin:$PATH"
source "$repo/modules/boxkit.sh"

mi_boxkit_install
[[ -d "$HOME/.local/share/boxkit/.git" ]]
[[ -L "$HOME/.local/bin/boxkit" ]]
[[ "$(readlink "$HOME/.local/bin/boxkit")" == "$HOME/.local/share/boxkit/boxkit" ]]
[[ "$(grep -c '^clone ' "$MI_BOXKIT_GIT_LOG")" == 1 ]]

# Reinstallation is idempotent; update pulls without cloning again.
mi_boxkit_install
[[ "$(grep -c '^clone ' "$MI_BOXKIT_GIT_LOG")" == 1 ]]
mi_boxkit_update
grep -Fqx -- "-C $HOME/.local/share/boxkit pull --ff-only" "$MI_BOXKIT_GIT_LOG"

# Mi deploy must not fetch or update Boxkit.
source "$repo/distro/_common.sh"
deploy_settings() { :; }
install_basic_packages() { :; }
: > "$MI_BOXKIT_GIT_LOG"
perform ':' ':' ':' deploy
[[ ! -s "$MI_BOXKIT_GIT_LOG" ]]

# Both install and update invoke the same shared helper on the host.
perform ':' ':' ':' install
[[ ! -s "$MI_BOXKIT_GIT_LOG" ]]
perform ':' ':' ':' update
grep -q '^\-C .* pull --ff-only$' "$MI_BOXKIT_GIT_LOG"

# Refuse to overwrite unrelated binaries/symlinks.
rm "$HOME/.local/bin/boxkit"
printf 'existing\n' > "$HOME/.local/bin/boxkit"
if mi_boxkit_install; then
  echo 'FAIL: overwrote existing boxkit executable' >&2
  exit 1
fi
grep -qx existing "$HOME/.local/bin/boxkit"

rm "$HOME/.local/bin/boxkit"
ln -s /tmp/other-boxkit "$HOME/.local/bin/boxkit"
if mi_boxkit_install; then
  echo 'FAIL: overwrote unrelated boxkit symlink' >&2
  exit 1
fi
[[ "$(readlink "$HOME/.local/bin/boxkit")" == /tmp/other-boxkit ]]

# Update on a fresh machine is equivalent to first installation.
rm "$HOME/.local/bin/boxkit"
rm -rf "$HOME/.local/share/boxkit"
: > "$MI_BOXKIT_GIT_LOG"
mi_boxkit_update
grep -q '^clone --depth 1 ' "$MI_BOXKIT_GIT_LOG"
[[ -L "$HOME/.local/bin/boxkit" ]]

echo 'Mi Boxkit installation tests passed.'
