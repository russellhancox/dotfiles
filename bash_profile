# Don't try anything if the shell isn't interactive
[[ $- != *i* ]] && return

# I use Vim
hash vim >/dev/null 2>&1 && export EDITOR='vim'

# Enable Bash completions where available
[[ -e "/usr/local/etc/bash_completion.d/tmux" ]] && source /usr/local/etc/bash_completion.d/tmux
[[ -e "/usr/local/etc/bash_completion.d/git" ]] && source /usr/local/etc/bash_completion.d/git

# Generic aliases
alias ll="ls -l"
alias la="ls -al"
alias psgrep="ps -ef | grep -v grep | grep"
alias servehere="python -m SimpleHTTPServer 2>/dev/null"

# Configure shell options
shopt -s cdspell
shopt -s histappend
unset HISTFILESIZE
HISTSIZE=1000000
HISTCONTROL=ignoreboth
HISTIGNORE='ls:bg:fg:history'
HISTTIMEFORMAT='%F %T '
stty -ixon

function os_specifics
{
  case `uname` in
      "Darwin")
          alias ls="ls -Gh"
          ;;
      "Linux")
          alias ls="ls --color -h"
          alias ps="ps f"

          # I prefer OSX LS_COLORS..
          LS_COLORS="rs=0:di=00;34:ln=01;36:hl=44;37:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=30;43:st=37;44:ex=00;31:"
          LS_COLORS="${LS_COLORS}*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:"
          LS_COLORS="${LS_COLORS}*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:"
          LS_COLORS="${LS_COLORS}*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:"
          LS_COLORS="${LS_COLORS}*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:"
          LS_COLORS="${LS_COLORS}*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:"
          LS_COLORS="${LS_COLORS}*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:";
          export LS_COLORS
          ;;
  esac
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
