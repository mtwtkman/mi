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
MI_PACKAGES="neovim git" HOME=./.boxkit/home mi sweep
```

`mi sweep` selects all backup generations (`.mi.bk` and `.mi.bk.*`)
associated with each selected package destination. The obsolete `--full`
option is not accepted.

`MI_PACKAGES` restricts the command to selected packages. If unset,
`MI_PROFILE=container` selects container defaults, while host mode selects
all packages. `HOME` may be absolute or relative to the invocation
directory. With `MI_PACKAGES` set, `XDG_CONFIG_HOME` is reset to
`$HOME/.config` to avoid an inherited host XDG destination.

Destination paths are derived from `packages/<package>/location`, not a
recursive search of HOME. Existing deployed configuration files are never
deleted. Mi lists candidates and requires explicit interactive `y`
confirmation before deletion. Any other answer cancels, and non-interactive
invocations do not delete backups.
