detect_architecture()
{
  case "$(uname -m)" in
    "x86_64") echo "amd64";;
    "aarch64") echo "arm64";;
  esac
}

detect_os()
{
  case "$(uname -o)" in
    "GNU/Linux" | "Android") echo "linux";;
    "Darwin") echo "darwin";;
  esac
}
