# Lang
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Git prompt support
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto verbose"
source ~/.dotfiles/git-prompt.sh
setopt PROMPT_SUBST

# Load colors
autoload -U colors && colors
export PS1="%{$fg[yellow]%}%n@%m %{$fg[blue]%}%(4~|.../%3~|%~) %{$fg[green]%}"'$(__git_ps1 "[%s]")'$'\n'"%{$fg[blue]%}» %{$reset_color%}"

# Set word boundaries for back/forward words
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# I use Vim
hash vim >/dev/null 2>&1 && export EDITOR='vim'

# Set some options
setopt AUTOCD               # Automatically change to typed directories
setopt AUTOPUSHD            # Add directory changes to stack automatically
setopt NOCLOBBER            # Prevent redirecting to existing files without >!
setopt INTERACTIVECOMMENTS  # Allow comments in interactive command entry

# Reset Ctrl+A, Ctrl+E
bindkey -e

# Configure completion
autoload -U compinit
compinit
zstyle ':completion:*' menu select

# Generic aliases
alias l="ls"
alias ll="ls -l"
alias la="ls -al"
alias less="less -R"
alias servehere="python -m SimpleHTTPServer 2>/dev/null"
alias killtabs="sed -i 's/	/  /g'"
alias sshonce="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias tailf="tail -F"

# This fixes bracketed paste problems (~00xxx01~) caused by a process turning on
# bracketed paste and then terminating before cleaning up after itself.
alias fixpaste='printf "\e[?2004l"'

function mkcd {
  mkdir -p "$*"
  cd "$*"
}

function hr {
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

# Make less better
if which pygmentize >/dev/null; then
  export LESSOPEN="|pygmentize -g %s 2>/dev/null"
  alias lessyn="/usr/bin/less -R"
  alias less="less -L"
fi

# Configure history
export HISTORY_IGNORE="(fg|bg|history|cd|pwd|exit)"
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_ALL_DUPS # Don't record duplicates
setopt HIST_IGNORE_SPACE    # Dont' record commands preceded with a space
setopt EXTENDED_HISTORY     # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY   # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY        # Share history between sessions
setopt HIST_REDUCE_BLANKS   # Remove unnecessary blanks before saving
HISTFILE=~/.zsh_history

# Go!
export GOPATH="${HOME}/src/go"

case `uname` in
  "Darwin")
      alias ls="ls -OGh"                            # Show file flags, colorized output and human file sizes
      alias catplist="plutil -convert xml1 -o -"    # cat a plist even if it's binary
      alias rootterm="sudo launchctl asuser 0 launchctl submit -l rahterm -- /Applications/Utilities/Terminal.app/Contents/MacOS/Terminal"
      alias roottermdel="sudo launchctl asuser 0 launchctl remove rahterm"
      alias sshfs="sshfs -oallow_root"
      alias xcopen="X=\$(pwd); while [[ "\${X}" != "/" ]]; do PROJ=\$(find \${X} -name '*.xcworkspace' -maxdepth 1 -prune -print -quit); [[ -z \${PROJ} ]] && PROJ=\$(find \${X} -name '*.xcodeproj' -maxdepth 1 -prune -print -quit); if [[ -n \${PROJ} ]]; then open \${PROJ}; break; fi; X=\$(dirname \${X}); done"

      BREW_PATH="${HOME}/brew"

      export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=${BREW_PATH}/cask"
      export HOSTNAME=$(scutil --get ComputerName)  # The normal hostname is often useless
      export PATH=${BREW_PATH}/bin:$PATH            # Add homebrew to path
      export PATH=$(gem environment gempath | cut -d':' -f1)/bin:$PATH # Add gem bin to path

      source "${BREW_PATH}/Library/Contributions/brew_bash_completion.sh" 2>/dev/null

      function title {
        echo -ne "\033]0;"$*"\007"
      }
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
    echo "${PS_OUT}" | grep ${@}
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
[[ -e "${HOME}/.zshrc.local" ]] && source ${HOME}/.zshrc.local
