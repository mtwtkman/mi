# Backup cleanup

Mi creates backup generations when a deployment replaces an existing
destination. The current naming scheme uses a UTC timestamp:

```text
nvim.mi.bk.20261114T053000Z
nvim.mi.bk.20261114T053000Z.1
```

Numeric suffixes prevent collisions within one second. Existing legacy
`.mi.bk` and `.mi.bk.N` files remain untouched during deployment.

## Cleanup

```bash
mi sweep
mi sweep --force
MI_PACKAGES="neovim git" HOME=./.boxkit/home mi sweep
box-misweep neovim,git
```

`mi sweep` selects all backup generations (`.mi.bk` and `.mi.bk.*`)
associated with each selected package destination. Without `MI_PACKAGES`,
all packages are included, even with `MI_PROFILE=container`. The obsolete
`--full` option is not accepted.

`box-misweep` may be run from any subdirectory of a Boxkit project. It finds the nearest `boxkit.ini`, reads `[container] home`, requires that directory to exist, and runs `mi sweep` with comma-separated package names converted to `MI_PACKAGES`. As with `mi sweep`, deletion requires interactive confirmation unless
`--force` is passed to `mi sweep` directly.

`MI_PACKAGES` restricts the command to selected packages. When unset,
`sweep` selects all packages regardless of `MI_PROFILE`. `HOME` may be absolute or relative to the invocation
directory. With `MI_PACKAGES` set, `XDG_CONFIG_HOME` is reset to
`$HOME/.config` to avoid an inherited host XDG destination.

Destination paths are derived from `packages/<package>/location`, not a
recursive search of HOME. Existing deployed configuration files are never
deleted. Mi lists candidates and requires explicit interactive `y`
confirmation before deletion by default. Any other answer cancels, and
non-interactive invocations do not delete backups unless `--force` is set.
`--force` skips confirmation, but still lists candidates and deletes only
backups derived from managed package locations.
