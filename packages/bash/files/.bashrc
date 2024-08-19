### BASIC ###
# ENVVAR
MI_HOME="${HOME}/.local/mi"
export PATH="${HOME}/.local/bin:${PATH}"
export XDG_CONFIG_HOME="${HOME}/.config"
if [[ $(uname -r) == *"WSL2"* ]]; then
  export LIBGL_ALWAYS_INDIRECT=0
fi

# COMPLETION
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && source /usr/share/bash-completion/bash_completion

# ALIAS
alias l="ls -CF"
alias la="ls -A"
alias ll="ls -alF"
alias mi="pushd ${MI_HOME}"
alias miup="mi && ./mi update && popd"
alias mii="mi && ./mi install"

### TOOL ###
# ASDF
if [ -d "${HOME}/.asdf" ]; then
  source "${HOME}/.asdf/asdf.sh"
  source "${HOME}/.asdf/completions/asdf.bash"
fi

# DIRENV
if command -v "direnv" &> /dev/null; then
  eval "$(direnv hook bash)"
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
  --preview='bat --style=full --color=always {}'
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
  source /usr/share/fzf/key-bindings.bash
  source /usr/share/fzf/completion.bash
fi

# GHCUP
[ -f "${HOME}/.ghcup/env" ] && . "${HOME}/.ghcup/env"

# GIT
if command -v "git" &> /dev/null; then
  ps1_git='$(__git_ps1 " (%s)")'
  export GIT_PS1_SHOWCOLORHINTS=true

  source /usr/share/git/completion/git-completion.bash
  source /usr/share/git/completion/git-prompt.sh
fi

# GPG
export GPG_TTY=$(tty)

# NVIM
if command -v "nvim" &> /dev/null; then
  export NVIM_LUASNIP_SNIPPETS_PATH="${HOME}/.config/nvim/snippets"
  export EDITOR="nvim"
  alias v="vim"
  alias vimdiff="nvim -d"
  alias vrh="vr -cc split --remote-wait"
  alias vrv="vr -cc vsplit --remote-wait"
  alias vt="vim +terminal"
  alias ve="vim ${MI_HOME}/packages/neovim/this"
  alias miedit="${EDITOR} ${MI_HOME}"
  alias mie="miedit"
  function vim()
  {
    if [ -z ${NVIM} ]; then
      nvim --listen /tmp/nvimsocket $@
    else
      nvr $@
    fi
  }
fi

# PODMAN
if command -v "podman" &> /dev/null; then
  source <(podman completion bash)
fi

# PROMPT
ps1_head="${PS1_HEAD:-}"
ps1_base="\e[1;34m\w\e[0m"
export PS1="${ps1_head}${ps1_base}${ps1_git}\n$ "
