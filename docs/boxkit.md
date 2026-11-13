# Boxkit integration

On the host, `./mi install` clones `https://github.com/mtwtkman/boxkit.git` with `--depth 1` into `${XDG_DATA_HOME:-$HOME/.local/share}/boxkit` and links `$HOME/.local/bin/boxkit` to the checkout's `boxkit` executable.

Running `./mi install` again reuses the existing checkout. `./mi update` updates it with `git pull --ff-only`; on a fresh machine, update installs it. `./mi deploy` never downloads or updates Boxkit. Container-profile deployment is unchanged. An existing unmanaged binary or symlink is not overwritten.

Ensure `$HOME/.local/bin` is on `PATH`, then run `boxkit init` from a project.
