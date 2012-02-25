# Don't try anything if the shell isn't interactive
[[ $- != *i* ]] && return

# If not running under tmux, attach to tmux shells session.
[[ $TERM != "screen" ]] && tmux attach -t shells && exit

# Enable emacs mode
set -o emacs

# Set editor
EDITOR=emacs

# Enable Bash completions where available
[[ -e "/usr/local/etc/bash_completion.d/tmux" ]] && source /usr/local/etc/bash_completion.d/tmux
[[ -e "/usr/local/etc/bash_completion.d/git" ]] && source /usr/local/etc/bash_completion.d/git

# Generic aliases
alias l="ls -l"
alias la="ls -al"
alias e="emacs"
alias psgrep="ps -ef | grep -v grep | grep"
alias servehere="python -m SimpleHTTPServer 2>/dev/null"

function os_specifics
{
  if [[ `uname` == 'Darwin' ]]; then
    alias ls="ls -Gh"
  fi
}
os_specifics


# Set shell line 
function ps1
{
  local BLUE="\[\033[0;34m\]"
  local RED="\[\033[0;31m\]"
  local YELLOW="\[\033[0;33m\]"
  local GREEN="\[\033[0;32m\]"
  local DEFAULT="\[\033[0;00m\]"
  
  if [[ -n $(type -t __git_ps1) ]]; then
    PS1="${YELLOW}\h ${RED}\W${GREEN}\$(__git_ps1) ${BLUE}\$ ${DEFAULT}"
		#export PS1
  else
    PS1="${YELLOW}\h ${RED}\W ${BLUE}\$ ${DEFAULT}"
  fi
}
ps1

