# Backup cleanup

Run `./mi sweep` to list `.mi.bk` backups corresponding to the currently selected Mi package destinations. The command asks for explicit `y` confirmation before permanently deleting files or directories. Any other response cancels deletion. Non-interactive invocation refuses to delete.

The command works for both host and `MI_PROFILE=container` deployments. `MI_PACKAGES` can restrict the package selection. Unrelated files with a `.mi.bk` suffix outside Mi-managed destinations are not scanned.

## Conflicting backups during deploy

When a destination needs updating and `.mi.bk` already exists, `mi deploy`
asks for one of the following actions on an interactive terminal:

- `r`: preserve the existing backup as `.mi.bk.1`, `.mi.bk.2`, etc.
  (first available suffix), then move the current destination to `.mi.bk`.
- `o`: permanently delete the existing `.mi.bk` (file, directory, or link),
  then move the current destination into its place.
- `c`, Enter, or any other response: cancel without changing either path.

Without a terminal, Mi stops rather than silently removing or rotating an
existing backup. If the destination is already an identical copy (or the
correct symlink), no new backup or prompt is needed.

`mi sweep` continues to target the most recent `.mi.bk` files only.
Rotated `.mi.bk.N` backups are intentionally retained for manual review
and cleanup.
