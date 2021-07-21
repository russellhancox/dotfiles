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
alias servehere="python3 -m http.server"
alias killtabs="sed -i 's/	/  /g'"
alias sshonce="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias tailf="tail -F"
hash hub >/dev/null 2>&1 && alias git="hub"

function mkcd {
  mkdir -p "$*"
  cd "$*"
}

# Configure shell options
shopt -s cdspell
export PROMPT_DIRTRIM=5
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
      alias xcopen="X=\$(pwd); while [[ "\${X}" != "/" ]]; do PROJ=\$(find \${X} -name '*.xcworkspace' -maxdepth 1 -prune -print -quit); [[ -z \${PROJ} ]] && PROJ=\$(find \${X} -name '*.xcodeproj' -maxdepth 1 -prune -print -quit); if [[ -n \${PROJ} ]]; then open \${PROJ}; break; fi; X=\$(dirname \${X}); done"

      BREW_PATH="${HOME}/brew"

      export HOSTNAME=$(scutil --get ComputerName)  # The normal hostname is often useless
      export PATH=${BREW_PATH}/bin:$PATH            # Add homebrew to path
      export GREP_OPTIONS="--color=auto"

      source "${BREW_PATH}/Library/Contributions/brew_bash_completion.sh" 2>/dev/null
      ;;
  "Linux")
      alias ls="ls --color -h"                      # Show colorized output and human file sizes
      alias ps="ps f"                               # Show processes as an ASCII tree
      export HOSTNAME=$(echo $HOSTNAME | cut -d . -f 1)
      ;;
esac

# Process list search with full output
function psgrep {
  PS_OUT=$(ps -eo user,pid,ppid,%cpu,%mem,vsz,rss,tt,stat,start,time,command)
  echo "${PS_OUT}" 2>/dev/null| head -n1
  if [[ -n ${1} ]]; then
    echo "${PS_OUT}" | grep ${@}
  else
    echo "${PS_OUT}"
  fi
}

# Set shell line
function prompt_lastcmd {
  RETVAL=$?
  [[ $RETVAL -ne 0 ]] && printf "($RETVAL) "
}

function prompt_jobs {
  [[ $(jobs -l | wc -l) -gt 0 ]] && printf "⚙ "
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
  DEFAULT="\[$(tput sgr0)\]"
  BLACK="\[$(tput setaf 0)\]"
  RED="\[$(tput setaf 1)\]"
  GREEN="\[$(tput setaf 2)\]"
  YELLOW="\[$(tput setaf 3)\]"
  BLUE="\[$(tput setaf 4)\]"
  PURPLE="\[$(tput setaf 5)\]"
  CYAN="\[$(tput setaf 6)\]"
  WHITE="\[$(tput setaf 7)\]"

  export PS1="${DEFAULT}${YELLOW}\u@${HOSTNAME} ${BLUE}\w ${RED}"\
"\$(prompt_lastcmd 2>/dev/null)${BLUE}\$(prompt_jobs 2>/dev/null)"\
"${GREEN}\$(prompt_git 2>/dev/null)\n${BLUE}»${DEFAULT} "
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

# Potentially add cargo to path
[[ -e "${HOME}/.cargo/bin" ]] && PATH="${HOME}/.cargo/bin:${PATH}"

# If a local customization file exists, use it..
[[ -e "${HOME}/.bash_profile.local" ]] && source ${HOME}/.bash_profile.local
