# Mi

Mi manages personal development environment configuration and distribution-specific packages.

## Installation

```sh
curl https://raw.githubusercontent.com/mtwtkman/mi/main/setup | bash -s
```

## Usage

```sh
./mi deploy   # Deploy managed configuration
./mi deploy neovim git  # Deploy only selected configuration packages
./mi deploy --home /path/to/container/home --mode copy neovim
./mi install  # Install configured packages and deploy
./mi update   # Update installed packages and managed tools
./mi sweep    # Review and remove Mi backup files (confirmation required)
```

For container configuration, use `MI_PROFILE=container ./mi deploy`.

## Documentation

- [Backup cleanup](docs/backup-cleanup.md)
- [SSH agent](docs/ssh-agent.md)
- [Boxkit integration](docs/boxkit.md)
- [Arch Linux package management](docs/arch-linux.md)
