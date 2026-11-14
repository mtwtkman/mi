# Backup cleanup

Mi creates backup generations when a deployment replaces an existing
destination. The current naming scheme uses a UTC timestamp:

```text
nvim.mi.bk.20261114T053000Z
nvim.mi.bk.20261114T053000Z.1
```

Numeric suffixes prevent collisions within one second. Existing legacy
`.mi.bk` and `.mi.bk.N` files remain untouched during deployment.

## Cleanup commands

```bash
mi sweep
mi sweep --full
MI_PACKAGES="neovim git" HOME=./.boxkit/home mi sweep --full
```

- `mi sweep` only selects the original unsuffixed `.mi.bk` files.
- `mi sweep --full` additionally selects `.mi.bk.*` for each Mi-managed
  destination, including timestamped and legacy numbered backups.
- `MI_PACKAGES` restricts both commands to selected packages. If unset,
  `MI_PROFILE=container` selects the container defaults and host mode selects
  all packages.
- `HOME` may be absolute or relative to the directory where Mi is invoked.
  In selected-package or full sweeps, `XDG_CONFIG_HOME` is set to
  `$HOME/.config` to avoid accidentally using an inherited host XDG path.

Both commands derive destination paths from each selected
`packages/<package>/location`, and only look for backup filenames associated
with those destinations. They **do not recursively delete arbitrary backups
throughout HOME**.

Mi lists all candidates and requires explicit interactive `y` confirmation
before deleting them. Any other answer cancels; non-interactive invocation
never deletes backups. Existing deployed configuration files are not deleted.
