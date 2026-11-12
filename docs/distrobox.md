# Deploying Mi inside Distrobox

Mi supports an opt-in container profile that copies selected configurations into the
container's HOME instead of symlinking them to the Mi checkout.

## Usage

Run **inside** a Distrobox with its own HOME (recommended):

```bash
MI_PROFILE=container ./mi deploy
```

By default this deploys only `neovim` and `tmux`. To select packages explicitly:

```bash
MI_PROFILE=container MI_PACKAGES="git neovim tmux opencode" ./mi deploy
```

The container profile defaults to `MI_DEPLOY_MODE=copy`. To override the
mode explicitly (not recommended with a shared HOME):

```bash
MI_PROFILE=container MI_DEPLOY_MODE=link ./mi deploy
```

Container profile refuses `install`, `update`, and `purge`, avoiding
unexpected package-manager changes. The normal host profile is unchanged.

## Safety model

- Prefer `distrobox create --home /path/to/separate/home`.
- `--home` alone does **not** unmount the host HOME; Distrobox is
  integrated with the host. Do not treat Mi's copy mode as a security boundary.
- Copies are independent from the Mi checkout. Re-deploying unchanged files
  is a no-op; changes back up existing files to `.mi.bk`.
- If `.mi.bk` already exists, deployment stops rather than overwriting it.
- Copy mode is not a merge/sync operation; local modifications are backed up
  when source and destination differ.
- `MI_PACKAGES` is a space-separated list of directory names under `packages/`.
- Host-specific packages such as `sway`, `foot`, and `waybar` are excluded
  by default, but may be opted into deliberately.

## Tests

```bash
bash tests/deploy.sh
```

The regression suite uses temporary HOME directories and does not install packages.
