# Lang
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Nix. On macOS nix-darwin manages /etc/zshrc for this. On Linux the installer
# only writes /etc/profile.d, which zsh never reads - not even in login shells -
# so the profile has to go on PATH here. Must come before anything that looks
# for a Nix-installed binary.
typeset -U path                                   # keep PATH free of duplicates
[[ -d /nix/var/nix/profiles/default/bin ]] && path=(/nix/var/nix/profiles/default/bin $path)
[[ -d "${HOME}/.nix-profile/bin" ]] && path=("${HOME}/.nix-profile/bin" $path)
[[ -r "${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh" ]] &&
  source "${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh"

# Set word boundaries for back/forward words
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# I use Vim/nvim. Prefer nvim where it exists, fall back to vim where it doesn't.
if hash nvim >/dev/null 2>&1; then
  export EDITOR='nvim'
  alias vi="nvim"
  alias vim="nvim"
elif hash vim >/dev/null 2>&1; then
  export EDITOR='vim'
fi

# Set some options
setopt AUTOCD               # Automatically change to typed directories
setopt AUTOPUSHD            # Add directory changes to stack automatically
setopt NOCLOBBER            # Prevent redirecting to existing files without >!
setopt INTERACTIVECOMMENTS  # Allow comments in interactive command entry

# Reset Ctrl+A, Ctrl+E
bindkey -e
# Make forward delete work
bindkey "^[[3~"   delete-char
bindkey "^[[3;5~" delete-char

# Configure completion
autoload -Uz compinit
compinit
fpath=( ~/.zsh/completion $fpath )
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/completion-cache

# Load Homebrew completions
if [[ -e "/opt/homebrew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  FPATH=$FPATH:/opt/homebrew/share/zsh/site-functions

  # brew's own completions live in the Nix store since nix-homebrew took over
  # the prefix - only formula completions still land in site-functions above.
  # Resolve the managed symlink each time so the path follows store updates.
  [[ -L /opt/homebrew/Library/Homebrew ]] &&
    FPATH=$FPATH:${$(readlink /opt/homebrew/Library/Homebrew):h:h}/completions/zsh

  compinit
fi

# Configure autosuggestions. home-manager links this out of the Nix store.
[[ -r ~/.zsh/plugins/zsh-autosuggestions.zsh ]] && source ~/.zsh/plugins/zsh-autosuggestions.zsh

# Generic aliases
alias l="ls"
alias ll="ls -l"
alias la="ls -al"
alias less="less -R"
alias servehere="python3 -m http.server"
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
unsetopt SHARE_HISTORY      # Don't share history between sessions
setopt HIST_REDUCE_BLANKS   # Remove unnecessary blanks before saving
HISTFILE=~/.zsh_history

case `uname` in
  "Darwin")
      alias ls="ls -OGh"                            # Show file flags, colorized output and human file sizes
      alias catplist="plutil -convert xml1 -o -"    # cat a plist even if it's binary
      alias xcopen="X=\$(pwd); while [[ "\${X}" != "/" ]]; do PROJ=\$(find \${X} -name '*.xcworkspace' -maxdepth 1 -prune -print -quit); [[ -z \${PROJ} ]] && PROJ=\$(find \${X} -name '*.xcodeproj' -maxdepth 1 -prune -print -quit); if [[ -n \${PROJ} ]]; then open \${PROJ}; break; fi; X=\$(dirname \${X}); done"
      alias lsregister="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"
      alias cloudlogin="gcloud auth login --update-adc && aws sso login"
      alias nix-rebuild="sudo darwin-rebuild switch --flake ~/.dotfiles#mac"

      export HOSTNAME=$(scutil --get ComputerName)  # The normal hostname is often useless
      ;;
  "Linux")
      alias ls="ls --color -h"                      # Show colorized output and human file sizes
      alias ps="ps f"                               # Show processes as an ASCII tree
      alias nix-rebuild='home-manager switch -b hm-bak --flake ~/.dotfiles#linux-$(uname -m)'

      export HOSTNAME=$(echo $HOSTNAME | cut -d . -f 1)

      [[ -e "${HOME}/.ls_colors" ]] && source ${HOME}/.ls_colors
      ;;
esac

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

# Load starship - fall back to the ASCII-only config where a Nerd Font is unlikely.
# Set STARSHIP_CONFIG yourself (e.g. in .zshrc.local) to force either one.
if [[ -z "${STARSHIP_CONFIG}" ]]; then
  [[ -r "${HOME}/.config/starship/plain.toml" ]] && export STARSHIP_CONFIG="${HOME}/.config/starship/plain.toml"

  if [[ "${TERM}" == (*-ghostty) && -r "${HOME}/.config/starship/fancy.toml" ]]; then
    export STARSHIP_CONFIG="${HOME}/.config/starship/fancy.toml"
  fi
fi
hash starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# If a local customization file exists, use it..
[[ -e "${HOME}/.zshrc.local" ]] && source ${HOME}/.zshrc.local

# Enable syntax highlighting. This needs to be near the end to avoid being unloaded by other modules.
[[ -r ~/.zsh/plugins/zsh-syntax-highlighting.zsh ]] && source ~/.zsh/plugins/zsh-syntax-highlighting.zsh
