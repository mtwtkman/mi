# Deploying Mi inside development containers

Mi's container profile is independent of the container engine. It is supported
inside development containers managed by Boxkit (rootless Podman), as well as
other environments with a separate HOME.

## Usage

Run inside the container:

```bash
MI_PROFILE=container ./mi deploy
```

The default configuration packages are `git`, `opencode`, and `neovim`.
Command-line tools such as `fzf` and `ripgrep` must be installed separately
using the container's package manager, for example with
`[packages] additional = ...` in `boxkit.ini`.

To select packages explicitly:

```bash
MI_PROFILE=container MI_PACKAGES="git opencode neovim" ./mi deploy
```

The container profile uses `MI_DEPLOY_MODE=copy` by default. An explicit
`MI_DEPLOY_MODE=link` is available, but the default avoids references to
the Mi checkout when it is not shared with the container.

In the container profile, `install`, `update`, and `purge` are refused
to avoid unintended package-manager operations. The host profile is unaffected.

## Safety and persistence

- Use a separate container HOME rather than directly reusing the host HOME.
  Boxkit's `.boxkit/home` is separate and persists across container
  recreation.
- Copy mode is not a security boundary. Host access depends on runtime
  mounts and integrations such as SSH agent and D-Bus.
- Re-deploying unchanged files does nothing. Differences back up the prior
  destination to `.mi.bk`; existing backups are not overwritten.
- `MI_PACKAGES` accepts a space-separated list of Mi package names.
- Host-specific packages such as `sway`, `foot`, `tmux`, and `waybar`
  are not selected in the default container profile.

## Tests

```bash
bash tests/deploy.sh
```

These tests use isolated temporary HOME directories without installing
packages.
