curl https://raw.githubusercontent.com/mtwtkman/mi/main/setup | bash -s

## Backup cleanup

Run `./mi sweep` to list `.mi.bk` backups corresponding to the currently
selected Mi package destinations. The command asks for explicit `y`
confirmation before permanently deleting files or directories. Any other
response cancels deletion. Non-interactive invocation refuses to delete.

The command works for both host and `MI_PROFILE=container` deployments.
`MI_PACKAGES` can restrict the package selection. Unrelated files with a
`.mi.bk` suffix outside Mi-managed destinations are not scanned.

## SSH agent

On Linux hosts, `./mi deploy` installs and enables the user-level
`ssh-agent.service`. Repeated deployment skips activation when the installed
unit matches and the service is already enabled and active.
