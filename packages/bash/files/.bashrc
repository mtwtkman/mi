### BASIC ###
if [ -e "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ENVVAR
MI_HOME="${HOME}/.local/mi"
LC_ALL=C
export PATH="${HOME}/.local/bin:${PATH}"
export XDG_CONFIG_HOME="${HOME}/.config"
if [[ $(uname -r) == *"WSL2"* ]]; then
  export LIBGL_ALWAYS_INDIRECT=0
fi
if [[ -f "${HOME}/.local/env" ]]; then
  source ${HOME}/.local/env
fi

osname="$(uname -o | tr "[:upper:]" "[:lower:]")"
declare -a candidates=("linux" "darwin")
for o in "${candidates[@]}"
do
  if [[ "${osname}" =~ "${o}" ]]; then
    ostype="${o}"
    break
  fi
done

# COMPLETION
case "${ostype}" in
  linux) [[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && source /usr/share/bash-completion/bash_completion;;
  darwin) [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]] && . "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh";;
esac

# ALIAS
alias l="ls -CF"
alias la="ls -A"
alias ll="ls -alF"
alias mi="pushd ${MI_HOME}"
alias miup="mi && ./mi update && popd"
alias miclean="mi && ./mi purge && popd"
alias micl="miclean"
alias boxkit="curl https://raw.githubusercontent.com/mtwtkman/boxkit/main/boxkit | sh -s"

### TOOL ###
# DISTROBOX
if [[ ${CONTAINER_ID} ]]; then
  distrobox_icon=" -  : \e[33m${CONTAINER_ID}\e[0m"
else
  distrobox_icon=""
fi

# DOCKER
if command -v "docker" &> /dev/null; then
  alias c="docker"
fi

# FZF
if command -v "fzf" &> /dev/null; then
  export FZF_DEFAULT_COMMAND="rg --files --no-ignore --hidden --follow -g \"!{.git,node_modules}/*\" 2> /dev/null"
  export FZF_DEFAULT_OPTS="""
  --reverse
  --extended
  --multi
  --inline-info
  --prompt='fzf>'
  --ansi
  --preview='cat {}'
  --bind=ctrl-f:page-down,ctrl-b:page-up,'ctrl-v:become(vim {})',ctrl-^:first,ctrl-/:last
  --color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  """
  export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

  fif()
  {
    if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
    rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
  }

  fh()
  {
    eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
  }

  fcd()
  {
    command pushd $(fd . $@ -t d | fzf)
  }

  case "${ostype}" in
    linux) eval "$(fzf --bash)";;
    darwin)
      source "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.bash"
      source "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.bash"
      ;;
  esac
fi

# GIT
if command -v "git" &> /dev/null; then
  ps1_git='$(__git_ps1 " (%s)")'
  export GIT_PS1_SHOWCOLORHINTS=true

  case "${ostype}" in
    linux)
      [[ -f "/usr/share/bash-completion/completions/git" ]] && source /usr/share/bash-completion/completions/git
      [[ -f "/usr/share/git/completion/git-completion.bash" ]] && source /usr/share/git/completion/git-completion.bash
      [[ -f "/usr/share/git/completion/git-prompt.sh" ]] && source /usr/share/git/completion/git-prompt.sh
      ;;
    darwin)
      source "${HOMEBREW_PREFIX}/opt/git/etc/bash_completion.d/git-completion.bash"
      source "${HOMEBREW_PREFIX}/opt/git/etc/bash_completion.d/git-prompt.sh"
      ;;
  esac
else
  ps1_git=""
fi

# GPG
export GPG_TTY=$(tty)

# NNN
if command -v "nnn" &> /dev/null; then
  export NNN_OPTS="adeH"
  export NNN_PLUG="f:finder"
fi

# NVIM
if command -v "nvim" &> /dev/null; then
  export NVIM_LUASNIP_SNIPPETS_PATH="${HOME}/.config/nvim/snippets"
  export EDITOR="nvim"
  alias vim="nvim"
  alias v="vim"
  alias vimdiff="nvim -d"
  alias vrh="vr -cc split --remote-wait"
  alias vrv="vr -cc vsplit --remote-wait"
  alias vt="vim +terminal"
  alias ve="vim ${MI_HOME}/packages/neovim/this"
  alias vup="vim +LazySYnc"
  alias miedit="${EDITOR} ${MI_HOME}"
  alias mie="miedit"
  export MANPAGER="nvim +Man!"
fi

# PODMAN
if command -v "podman" &> /dev/null; then
  source <(podman completion bash)
  alias podman="env -u DBUS_SESSION_BUS_ADDRESS podman"
  alias c="podman"
fi

# POI
if command -v "poi" &> /dev/null; then
  alias rm="poi toss"
  export NVIM_TREE_TRASH_COMMAND="poi toss"
fi

# SSH
if systemctl --user status ssh-agent | rg running &> /dev/null; then
  export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi

# TMUX
if [ "${TMUX}" ]; then
  tmux_icon=" "
else
  tmux_icon=""
fi

### Finalize User Setting ###
# PROMPT
ps1_head="${PS1_HEAD:-}"
ps1_base="\w"
export PS1="${tmux_icon}${ps1_head}${ps1_base}${ps1_git}${distrobox_icon}\n$ "

# EXTRA
extra_bashrc="${HOME}/.bashrc.extra"
[[ -e "${extra_bashrc}" ]] && source "${extra_bashrc}"
