#!/bin/bash
show()
{
  eval "${MI_ECHO_ASCII_CHARA} \"\\033[0;\${1}\\033[0m\""
}

red()
{
  show "31m${1}"
}

green()
{
  show "32m${1}"
}

yellow()
{
  show "33m${1}"
}

blue()
{
  show "34m${1}"
}
