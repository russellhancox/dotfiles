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
alias servehere="python -m SimpleHTTPServer 2>/dev/null"
alias killtabs="sed -i 's/	/  /g'"
alias sshonce="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias cd..="echo 'cd SPACE .., idiot.'; cd .."
alias tailf="tail -F"
hash hub >/dev/null 2>&1 && alias git="hub"

# Make less better
if which pygmentize >/dev/null; then
  export LESSOPEN="|pygmentize -g %s 2>/dev/null"
fi

# Configure shell options
shopt -s cdspell
export PROMPT_DIRTRIM=5
export GREP_OPTIONS="--color=auto"
export LESSHISTFILE="-"
export HISTIGNORE="fg bg history"
export HISTSIZE=1000000
export HISTTIMEFORMAT='%F %T '
stty -ixon

# Configure Ctrl+W to backwards-kill-word so I can Ctrl+W with file paths
stty werase undef
bind '"\C-w": backward-kill-word'

case `uname` in
  "Darwin")
      alias ls="ls -OGh"                            # Show file flags, colorized output and human file sizes
      alias catplist="plutil -convert xml1 -o -"    # cat a plist even if it's binary
      alias rootterm="sudo launchctl asuser 0 launchctl submit -l rahterm -- /Applications/Utilities/Terminal.app/Contents/MacOS/Terminal"
      alias roottermdel="sudo launchctl asuser 0 launchctl remove rahterm"
      alias sshfs="sshfs -o allow_root"
      alias xcopen="proj=\$(find . -name '*xcworkspace' -maxdepth 1 -prune -print -quit); if [[ -n \"\${proj}\" ]]; then open \"\${proj}\"; else proj=\$(find . -name '*.xcodeproj' -maxdepth 1 -print -prune -quit); if [[ -n \"\${proj}\" ]]; then open \"\${proj}\"; else echo 'no project found'; fi; fi"

      export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=${HOME}/.cask"
      export HOSTNAME=$(scutil --get ComputerName)  # The normal hostname is often useless
      export PATH=${HOME}/.brew/bin:$PATH           # Add homebrew to path
      export PATH=$(gem environment gempath | cut -d':' -f1)/bin:$PATH # Add gem bin to path

      source "$(brew --prefix)/Library/Contributions/brew_bash_completion.sh" 2>/dev/null
      ;;
  "Linux")
      alias ls="ls --color -h"                      # Show colorized output and human file sizes
      alias ps="ps f"                               # Show processes as an ASCII tree
      export HOSTNAME=$(echo $HOSTNAME | cut -d . -f 1)
      [[ -e "${HOME}/.ls_colors" ]] && source ${HOME}/.ls_colors
      ;;
esac

# Process list search with full output
function psgrep {
  PS_OUT=$(ps -eo user,pid,ppid,%cpu,%mem,vsz,rss,tt,stat,start,time,command)
  echo "${PS_OUT}" 2>/dev/null| head -n1
  if [[ -n ${1} ]]; then
    echo "${PS_OUT}" | grep ${1}
  else
    echo "${PS_OUT}"
  fi
}

#
function shellbadge {
  if [[ ${TERM_PROGRAM} != iTerm* ]]; then
    echo "This only works on iTerm2"
  else
    printf "\e]1337;SetBadgeFormat=%s\a" $(echo -n ${1} | base64)
  fi
}

# Set shell line
function prompt_lastcmd {
  RETVAL=$?
  [[ $RETVAL -ne 0 ]] && printf "($RETVAL) "
}

function prompt_jobs {
  [[ $(jobs -l | wc -l) -gt 0 ]] && printf "⚙  "
}

function prompt_git {
  GIT_STATUS=$(git status --porcelain 2>&1)
  if [ $? -eq 0 ]; then
    GIT_BRANCH=$(git branch | grep '*' | awk '{print $2}')
    if echo ${GIT_STATUS} | grep -q 'M'; then
      printf "[${GIT_BRANCH} M] "
    else
      printf "[${GIT_BRANCH}] "
    fi
  fi
}

function ps1 {
  DEFAULT='\[\[\e[0m\]'
  BLACK='\[\e[0;30m\]'
  RED='\[\e[0;31m\]'
  GREEN='\[\e[0;32m\]'
  YELLOW='\[\e[0;33m\]'
  BLUE='\[\e[0;34m\]'
  PURPLE='\[\e[0;35m\]'
  CYAN='\[\e[0;36m\]'
  WHITE='\[\e[0;37m\]'

  export PS1="${YELLOW}\u@${HOSTNAME} ${BLUE}\w ${RED}"\
"\$(prompt_lastcmd 2>/dev/null)${BLUE}\$(prompt_jobs 2>/dev/null)"\
"${GREEN}\$(prompt_git 2>/dev/null)\n${BLUE}» ${DEFAULT}"
}
ps1

# Add color to manpages
function man() {
  LESS_TERMCAP_mb=$(printf "\e[1;31m") \
  LESS_TERMCAP_md=$(printf "\e[1;31m") \
  LESS_TERMCAP_me=$(printf "\e[0m") \
  LESS_TERMCAP_se=$(printf "\e[0m") \
  LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
  LESS_TERMCAP_ue=$(printf "\e[0m") \
  LESS_TERMCAP_us=$(printf "\e[1;32m") \
  /usr/bin/man "$@"
}

# If a local customization file exists, use it..
[[ -e "${HOME}/.bash_profile.local" ]] && source ${HOME}/.bash_profile.local
