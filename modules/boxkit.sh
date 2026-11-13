#!/usr/bin/env bash
# Install and update Boxkit independently of Mi's managed dotfiles.
# The checkout lives under XDG_DATA_HOME (or ~/.local/share), with a stable
# entry point in ~/.local/bin.
mi_boxkit_paths() {
  BOXKIT_CHECKOUT="${XDG_DATA_HOME:-$HOME/.local/share}/boxkit"
  BOXKIT_BIN="$HOME/.local/bin/boxkit"
}

mi_boxkit_link() {
  local target="$BOXKIT_CHECKOUT/boxkit"
  [[ -f "$target" ]] || { printf 'Boxkit executable missing: %s\n' "$target" >&2; return 1; }
  mkdir -p -- "$(dirname -- "$BOXKIT_BIN")"
  if [[ -L "$BOXKIT_BIN" ]]; then
    [[ "$(readlink -- "$BOXKIT_BIN")" == "$target" ]] || {
      printf 'Refusing to replace a different symlink: %s\n' "$BOXKIT_BIN" >&2
      return 1
    }
    return 0
  fi
  [[ ! -e "$BOXKIT_BIN" ]] || {
    printf 'Refusing to overwrite an existing file: %s\n' "$BOXKIT_BIN" >&2
    return 1
  }
  ln -s -- "$target" "$BOXKIT_BIN"
}

mi_boxkit_install() {
  mi_boxkit_paths
  if [[ -d "$BOXKIT_CHECKOUT/.git" ]]; then
    :
  elif [[ -e "$BOXKIT_CHECKOUT" || -L "$BOXKIT_CHECKOUT" ]]; then
    printf 'Refusing to replace non-Git Boxkit directory: %s\n' "$BOXKIT_CHECKOUT" >&2
    return 1
  else
    mkdir -p -- "$(dirname -- "$BOXKIT_CHECKOUT")"
    git clone --depth 1 https://github.com/mtwtkman/boxkit.git "$BOXKIT_CHECKOUT" || return 1
  fi
  mi_boxkit_link
}

mi_boxkit_update() {
  mi_boxkit_paths
  if [[ ! -d "$BOXKIT_CHECKOUT/.git" ]]; then
    # Updates on a fresh machine should also install the tool.
    mi_boxkit_install
    return
  fi
  git -C "$BOXKIT_CHECKOUT" pull --ff-only || return 1
  mi_boxkit_link
}
