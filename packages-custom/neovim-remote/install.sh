here="$(dirname ${BASH_SOURCE[0]})"

asdf plugin add python
asdf install python latest
asdf global python latest
pip3 install neovim-remote
asdf reshim python
