# Shared Linux SSH agent

On Linux **host** deployments (`./mi deploy` or `./mi install`),
Mi installs `~/.config/systemd/user/ssh-agent.service` regardless of
whether the distribution uses Arch or Debian packaging.

The service listens at `%t/ssh-agent.sock` (typically
`$XDG_RUNTIME_DIR/ssh-agent.sock`). Mi **automatically enables and starts** the unit when a systemd user manager is available. It never kills existing SSH agents or replaces a different existing unit. Without a systemd user manager, installation succeeds but activation is skipped.

To activate manually if the user manager was unavailable during deployment:

```bash
systemctl --user daemon-reload
systemctl --user enable --now ssh-agent.service
```

Mi’s managed host `.bashrc` exports the stable socket automatically (and leaves forwarded sockets unchanged inside containers):

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
