__me_setup__test=./${dirname -- "${BASH_SOURCE[0]}"}

function __me_setup__test_failed_message()
{
  echo -e "\033[0;31mFAILED: ${1}\033[0m"
}

function __me_setup__test_passed_message()
{
  echo -e "\033[0;34mPASSED: ${1}\033[0m"
}

function __me_setup__test_run_case()
{
}

unset __me_setup__test
