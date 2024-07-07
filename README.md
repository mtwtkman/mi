# Mi
`mi` is a environment setup script for very personal use.

This script depends on ArchLinux heavily.

At first, all you need is `curl https://raw.githubusercontent.com/mtwtkman/mi/main/init | sh -s`.

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

## Configure isolatedly

### when the package has been installed via distro repository
`./force-deploy <package>`

### when the package has been installed by manually
`./force-deploy-custom <package>`

##  Update isolated

### when the package has been installed via distro repository
`./update <package>`

### when the package has been installed by manually
`./update-custom <package>`
