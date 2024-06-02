here="${dirname ${BASH_SOURCE[0]}}"

# ref: https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md
sh "${here}/../module/installer.sh" "podman"
