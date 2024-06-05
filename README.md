# Mi
`mi` is a environemnt setup script for personal use.

This script depends on ArchLinux heavily.

At first, all you need is `curl https://raw.githubusercontent.com/mtwtkman/mi/init | sh -s`.

# Usage

## Setup all dependencies
`./setup`

## Add package installation

### via distro repository
`./add-package <package>`

### by manually
`./add-package-custom <package>`

## Install isolatedly

### via distro repository
`./force-install <package>`

### by manually
`./force-install-custom <package>`

## Configure configuration isolatedly

### when the package has been installed via distro repository
`./force-deploy <package>`

### when the package has been installed by manually
`./force-deploy-custom <package>`

##  Update isolated

### when the package has been installed via distro repository
`./update <package>`

### when the package has been installed by manually
`./update-custom <package>`
