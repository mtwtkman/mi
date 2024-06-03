read -r -p "with config? [y/n]: " with_config
prompt="./module/helper/prompt"

package_name="${1}"

dest="./packages-custom/${package_name}/"

if [ -d "${dest}" ]; then
  sh "${prompt}/blue.sh" "\`${dest}\` has been created"
  exit 0
fi

mkdir "${dest}"

sh "${prompt}/green.sh" "created \`${dest}\`"

cat <<EOF > "${dest}/install.sh"
here="\${dirname \${BASH_SOURCE[0]}}"
EOF

if [ "${with_config}" != "y" ]; then
  exit 0
fi

cat <<EOF > "${dest}/deploy.sh"
here="\${dirname \${BASH_SOURCE[0]}}"
EOF
