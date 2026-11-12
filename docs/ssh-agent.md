# Shared Linux SSH agent

On Linux **host** deployments (`./mi deploy` or `./mi install`),
Mi installs `~/.config/systemd/user/ssh-agent.service` regardless of
whether the distribution uses Arch or Debian packaging.

The service listens at `%t/ssh-agent.sock` (typically
`$XDG_RUNTIME_DIR/ssh-agent.sock`). It is **not** enabled or started
automatically: this avoids disrupting an existing agent or starting
services during CI and provisioning.

Enable it on the host:

```bash
systemctl --user daemon-reload
systemctl --user enable --now ssh-agent.service
```

Expose the stable socket to host shells in your login environment
(for Bash, e.g. `~/.bash_profile` or a suitable shell startup file):

```bash
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.sock"
ssh-add ~/.ssh/id_ed25519
```

Avoid `eval "$(ssh-agent -s)"` in `.bashrc`: it spawns a new agent
for each shell and changes the socket location.

Boxkit's `./box enter` can discover this socket automatically when
creating a Distrobox container. The Mi `MI_PROFILE=container` profile
does not install or activate the host agent service.

An existing, different unit file is left unchanged and deployment
fails rather than overwriting it. The service assumes `/usr/bin/ssh-agent`
exists (install the distribution's OpenSSH client package). On Linux
systems without a systemd user manager, the unit can be installed but
cannot be activated with `systemctl --user`.
