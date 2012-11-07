# Don't try anything if the shell isn't interactive
[[ $- != *i* ]] && return

# I use Vim
hash vim >/dev/null 2>&1 && export EDITOR='vim'

# Enable Bash completions where available
[[ -e "/usr/local/etc/bash_completion.d/tmux" ]] && source /usr/local/etc/bash_completion.d/tmux
[[ -e "/usr/local/etc/bash_completion.d/git" ]] && source /usr/local/etc/bash_completion.d/git

# Enable Z
source ${HOME}/.dotfiles/z/z.sh

# Generic aliases
alias l="ls"
alias ll="ls -l"
alias la="ls -al"
alias psgrep="ps -ef | head -n1 && ps -ef | grep -v grep | grep -i"
alias servehere="python -m SimpleHTTPServer 2>/dev/null"
alias killtabs="sed -i 's/	/  /g'"

# Configure shell options
export GREP_OPTIONS="--color=auto"
shopt -s cdspell
shopt -s histappend
unset HISTFILESIZE
HISTSIZE=1000000
HISTCONTROL=ignoreboth
HISTIGNORE='ls:bg:fg:history'
HISTTIMEFORMAT='%F %T '
stty -ixon

case `uname` in
  "Darwin")
      alias ls="ls -Gh"
      ;;
  "Linux")
      alias ls="ls --color -h"
      alias ps="ps f"
      [[ -e "${HOME}/.ls_colors" ]] && source ${HOME}/.ls_colors
      ;;
esac

# Set shell line
function ps1
{
  local BLUE="\[\033[0;34m\]"
  local RED="\[\033[0;31m\]"
  local YELLOW="\[\033[0;33m\]"
  local GREEN="\[\033[0;32m\]"
  local DEFAULT="\[\033[0;00m\]"
  hostname=`hostname | cut -d . -f 1`

  if [[ -n $(type -t __git_ps1) ]]; then
    export PS1="${YELLOW}${hostname} ${RED}\W${GREEN}\$(__git_ps1) ${BLUE}\$ ${DEFAULT}"
  else
    export PS1="${YELLOW}${hostname} ${RED}\W ${BLUE}\$ ${DEFAULT}"
  fi
}
ps1

# If a local customization file exists, use it..
[[ -e "${HOME}/.bash_profile.local" ]] && source ${HOME}/.bash_profile.local
