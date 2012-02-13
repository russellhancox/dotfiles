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
alias psgrep="ps | grep -v grep | grep"
alias servehere="python -m SimpleHTTPServer 2>/dev/null"

# Set shell line 
function ps1
{
  local BLUE="\[\033[0;34m\]"
  local RED="\[\033[0;31m\]"
  local YELLOW="\[\033[0;33m\]"
  local GREEN="\[\033[0;32m\]"
  local DEFAULT="\[\033[0;00m\]"
  
  if [[ $(type -t __git_ps1) ]]; then
    export PS1="${YELLOW}\h ${RED}\W${GREEN}$(__git_ps1) ${BLUE}\$ ${DEFAULT}"
  else
    export PS1="${YELLOW}\h ${RED}\W ${BLUE}\$ ${DEFAULT}"
  fi
}
ps1

