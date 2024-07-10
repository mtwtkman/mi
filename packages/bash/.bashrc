# HOST
source /usr/share/git/completion/git-completion.bash
source /usr/share/git/completion/git-prompt.sh
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

MI_HOME="${HOME}/.local/mi"
PATH="${HOME}/.local/bin:${PATH}"

PS1='\e[1;34m\w\e[0m$(__git_ps1 " (%s)")\n\$ '
export XDG_CONFIG_HOME="${HOME}/.config"

if [[ $(uname -r) == *"WSL2"* ]]; then
  export LIBGL_ALWAYS_INDIRECT=0
fi

# GIT
export GIT_PS1_SHOWCOLORHINTS=true

function git:po()
{
  git push origin "$(git branch --show-current)"
}

# NVIM
export NVIM_LUASNIP_SNIPPETS_PATH="${HOME}/.config/nvim/snippets"
export EDITOR="nvim"

# DIRENV
eval "$(direnv hook bash)"

# GPG
export GPG_TTY=$(tty)

# FZF
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

# ALIAS
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias v='vim'
alias vim='nvim --listen /tmp/nvimsocket'
alias vimdiff='nvim -d'
alias vr='nvr -c '\''set number'\'''
alias vrh='vr -cc split --remote-wait'
alias vrv='vr -cc vsplit --remote-wait'
alias vt='vim +terminal'
alias edit:mi="vim ${MI_HOME}"
alias mi="pushd ${MI_HOME}"
alias miup="mi && ./setup && popd"

# ASDF
source "${HOME}/.asdf/asdf.sh"
source "${HOME}/.asdf/completions/asdf.bash"
