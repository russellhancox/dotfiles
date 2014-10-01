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
alias cd..="echo 'cd SPACE .., idiot.'; cd .."

# Make less better
if which pygmentize >/dev/null; then
  function lessh { pygmentize -g "$@" | /usr/bin/less -R; }
fi

# Configure shell options
export GREP_OPTIONS="--color=auto"
export LESSHISTFILE="-"
shopt -s cdspell
HISTIGNORE="fg bg history"
HISTSIZE=1000000
HISTTIMEFORMAT='%F %T '
stty -ixon

# Configure Ctrl+W to backwards-kill-word so I can Ctrl+W with file paths
stty werase undef
bind '"\C-w": backward-kill-word'

case `uname` in
  "Darwin")
      alias ls="ls -OGh"                                     # Show file flags, colorized output and human file sizes
      alias catplist="plutil -convert xml1 -o -"             # cat a plist even if it's binary
      alias rootterm="sudo launchctl submit -l rahterm /Applications/Utilities/Terminal.app/Contents/MacOS/Terminal"
      alias roottermdel="sudo launchctl remove rahterm"
      alias xcopen="proj=\$(find . -name '*xcworkspace' -maxdepth 1 -prune -print -quit); if [[ -n \"\${proj}\" ]]; then open \"\${proj}\"; else proj=\$(find . -name '*.xcodeproj' -maxdepth 1 -print -prune -quit); if [[ -n \"\${proj}\" ]]; then open \"\${proj}\"; else echo 'no project found'; fi; fi"
      export HOSTNAME=$(scutil --get ComputerName)           # The normal hostname is often useless
      unset PROMPT_COMMAND
      ;;
  "Linux")
      alias ls="ls --color -h"                               # Show colorized output and human file sizes
      alias ps="ps f"                                        # Show processes as an ASCII tree
      export HOSTNAME=$(echo $HOSTNAME | cut -d . -f 1)
      [[ -e "${HOME}/.ls_colors" ]] && source ${HOME}/.ls_colors
      ;;
esac

# Set shell line
function prompt_lastcmd {
  RETVAL=$?
  [[ $RETVAL -ne 0 ]] && printf "\342\234\227 "
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

# Set Terminal title
function settitle() {
  echo -ne "\033]0;$@\007";
}

# Add color to manpages
function man() {
  env \
  LESS_TERMCAP_mb=$(printf "\e[1;31m") \
  LESS_TERMCAP_md=$(printf "\e[1;31m") \
  LESS_TERMCAP_me=$(printf "\e[0m") \
  LESS_TERMCAP_se=$(printf "\e[0m") \
  LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
  LESS_TERMCAP_ue=$(printf "\e[0m") \
  LESS_TERMCAP_us=$(printf "\e[1;32m") \
  man "$@"
}

# If a local customization file exists, use it..
[[ -e "${HOME}/.bash_profile.local" ]] && source ${HOME}/.bash_profile.local
