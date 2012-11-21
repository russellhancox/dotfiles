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
alias psgrep="ps wwwaux | head -n1 && ps wwwaux | grep -v egrep | egrep -i"
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
      export HOSTNAME=$(scutil --get ComputerName)
      ;;
  "Linux")
      alias ls="ls --color -h"
      alias ps="ps f"
      export HOSTNAME=$(echo $HOSTNAME | cut -d . -f 1)
      [[ -e "${HOME}/.ls_colors" ]] && source ${HOME}/.ls_colors
      ;;
esac

# Set shell line
function git_prompt
{
  GIT_STATUS=$(git status --porcelain 2>&1)
  if [ $? -eq 0 ]; then
    GIT_BRANCH=$(git branch | grep '*' | awk '{print $2}')
    if echo ${GIT_STATUS} | grep -q 'M'; then
      echo "[${GIT_BRANCH} M]"
    else
      echo "[${GIT_BRANCH}]"
    fi
  fi
}
function ps1
{
  local BOLD="\[$(tput bold)\]"
  local RED="\[$(tput setaf 1)\]"
  local GREEN="\[$(tput setaf 2)\]"
  local YELLOW="\[$(tput setaf 3)\]"
  local BLUE="\[$(tput setaf 4)\]"
  local MAGENTA="\[$(tput setaf 5)\]"
  local CYAN="\[$(tput setaf 6)\]"
  local DEFAULT='\[$(tput sgr0)\]'

  PS1="${MAGENTA}[\!] ${YELLOW}\u@${HOSTNAME} ${RED}\w ${GREEN}\$(git_prompt)"
  PS1="${PS1}\n${BLUE}$ ${DEFAULT}"
  export PS1
}
ps1

# If a local customization file exists, use it..
[[ -e "${HOME}/.bash_profile.local" ]] && source ${HOME}/.bash_profile.local
