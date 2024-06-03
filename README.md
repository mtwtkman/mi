# Initial setup
`curl https://raw.githubusercontent.com/mtwtkman/mi/setup.sh | sh -s`

# Add package installation

## via distro repository
`./add-package.sh <package>`

## by manually
`./add-package-custom.sh <package>`

# Install isolatedly

## via distro repository
`./force-install.sh <package>`

## by manually
`./force-install-custom.sh <package>`

# Configure configuration isolatedly

## when the package has been installed via distro repository
`./force-deploy.sh <package>`

## when the package has been installed by manually
`./force-deploy-custom.sh <package>`


#  Update isolated

## when the package has been installed via distro repository
`./update.sh <package>`

## when the package has been installed by manually
`./update-custom.sh <package>`
