__mi_setup__module_package_dir_location=./$(dirname -- "${BASH_SOURCE[0]}")

packages=(
  "bash"
  "bat"
  "nvim"
  "tmux"
)

for i in "${packages}"; do
  source "${__mi_setup__module_package_dir_location}/${p}/main.sh"
done

unset __mi_setup__module_package_dir_location
