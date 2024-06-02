here="${dirname ${BASH_SOURCE[0]}}"

sh "${here}/../module/installer.sh" "docker"
# ref: https://docs.docker.com/engine/security/rootless/
curl -fsSL https://get.docker.com/rootless | sh
