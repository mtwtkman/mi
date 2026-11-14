# Backup cleanup

Mi creates a backup only when a deployment would replace an existing destination
(file, directory, or symlink). Backups use UTC timestamps, for example:

```text
nvim.mi.bk.20261114T053000Z
nvim.mi.bk.20261114T053000Z.1
```

The numeric suffix avoids collisions when multiple deployments occur in the
same second. Backups are created without prompts, so non-interactive
deployments (including `box-midep`) can proceed. Identical copies and
already-correct symlinks remain no-ops.

Previously created `.mi.bk` backups and `.mi.bk.N` rotated backups are
retained without modification.

## Cleanup

Run `./mi sweep` to review Mi backups for the selected package destinations.
It includes legacy `.mi.bk`, numbered legacy backups, and timestamped
backups, including timestamp collision suffixes. Only matching Mi-managed
destination names are considered; unrelated files are ignored.

`mi sweep` asks for explicit `y` confirmation before permanently deleting
all listed files and directories. Any other response cancels deletion.
Non-interactive invocation refuses to delete.

The command works for both host and `MI_PROFILE=container` deployments.
`MI_PACKAGES` can restrict the package selection.
