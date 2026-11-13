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

## Boxkit

On the host, `./mi install` clones `https://github.com/mtwtkman/boxkit.git`
with `--depth 1` into `${XDG_DATA_HOME:-$HOME/.local/share}/boxkit` and links
`$HOME/.local/bin/boxkit` to the checkout's `boxkit` executable.
Running `./mi install` again reuses the existing checkout. `./mi update`
updates it with `git pull --ff-only`; on a fresh machine, update installs it.
`./mi deploy` never downloads or updates Boxkit. Container-profile deployment
is unchanged. An existing unmanaged binary or symlink is not overwritten.

Ensure `$HOME/.local/bin` is on `PATH`, then run `boxkit init` from a project.

## Arch Linux package installation

On Arch Linux, `./mi install` installs only Mi's configured packages with
`paru -S --needed --noconfirm`. It does not trigger a full system upgrade
or rebuild unrelated installed AUR packages such as `howdy-git`.
The initial `paru` bootstrap installs `base-devel` without `-Syu`.
Keep the system reasonably up to date before installing new packages:
Arch Linux does not support partial upgrades.

Use `./mi update` for system-wide upgrades, including AUR packages.
This still runs `paru -Syu --noconfirm` followed by `checkrebuild`;
an unrelated broken AUR package can cause `update` to fail.
