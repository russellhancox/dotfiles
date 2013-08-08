# Don't try anything if the shell isn't interactive
[[ $- != *i* ]] && return

# I use Vim
hash vim >/dev/null 2>&1 && export EDITOR='vim'

# Enable Bash completions where available
[[ -e "/usr/local/etc/bash_completion.d/tmux" ]] && source /usr/local/etc/bash_completion.d/tmux
[[ -e "/usr/local/etc/bash_completion.d/git" ]] && source /usr/local/etc/bash_completion.d/git

# Generic aliases
alias l="ls"
alias ll="ls -l"
alias la="ls -al"
alias less="less -R"
alias psgrep="ps wwwaux | head -n1 && ps wwwaux | grep -v egrep | egrep -i"
alias servehere="python -m SimpleHTTPServer 2>/dev/null"
alias killtabs="sed -i 's/	/  /g'"
alias sshonce="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# Make less better
if which pygmentize >/dev/null; then
  function lessh { pygmentize -g "$@" | /usr/bin/less -R; }
fi

# Configure shell options
export GREP_OPTIONS="--color=auto"
export LESSHISTFILE="-"
shopt -s cdspell
unset HISTFILESIZE
HISTSIZE=1000000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE='ls:bg:fg:history'
HISTTIMEFORMAT='%F %T '
stty -ixon

# Configure Ctrl+W to backwards-kill-word so I can Ctrl+W with file paths
stty werase undef
bind '"\C-w": backward-kill-word'

case `uname` in
  "Darwin")
      alias ls="ls -OGh"                                    # Show file flags, colorized output and human file sizes
      alias catplist="plutil -convert xml1 -o -"            # cat a plist even if it's binary
      alias rootterm="sudo launchctl submit -l rahterm /Applications/Utilities/Terminal.app/Contents/MacOS/Terminal"
      alias roottermdel="sudo launchctl remove rahterm"
      export HOSTNAME=$(scutil --get ComputerName)          # The normal hostname is often useless
      ;;
  "Linux")
      alias ls="ls --color -h"                              # Show colorized output and human file sizes
      alias ps="ps f"                                       # Show processes as an ASCII tree
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
      echo "[${GIT_BRANCH} M] "
    else
      echo "[${GIT_BRANCH}] "
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

  PS1="${YELLOW}\u@${HOSTNAME} "
  PS1="${PS1}${RED}\W "
  PS1="${PS1}${GREEN}\$(git_prompt)"
  PS1="${PS1}${BLUE}$ ${DEFAULT}"
  export PS1
}
ps1

# If a local customization file exists, use it..
[[ -e "${HOME}/.bash_profile.local" ]] && source ${HOME}/.bash_profile.local
