if [[ ${PWD} != ${HOME} ]]; then
  echo "Must be run from ${HOME}"
  exit 0
fi
if ! hash git >/dev/null 2>&1; then
  echo "Please install Git"
  exit 0
fi

function symlinks {
  echo "Creating symlinks..."
  INCLUDE="bash_profile gitconfig gitignore vim vimrc tmux.conf"
  for f in "${INCLUDE}"; do
    ln -sf ${HOME}/.dotfiles/${f} ${HOME}/.${f}
  done
}

function homebrew {
  if uname | grep -q Darwin; then
    echo "Mac: installing homebrew and brew/cask packages"
    echo "This will take a while!"
    git clone https://github.com/Homebrew/brew "${HOME}/brew" >/dev/null || true
    export PATH=$PATH:${HOME}/brew/bin
  fi
}

function mac_defaults {
  if uname | grep -q Darwin; then
    echo "Mac: setting some defaults"
    ${HOME}/.dotfiles/osx_defaults.sh
  fi
}

function vim {
  echo "Installing latest vundle bundle"
  rm -fr ${HOME}/.vim/bundle/vundle/* ${HOME}/.vim/bundle/vundle/.* 2>/dev/null
  git clone https://github.com/gmarik/vundle.git ${HOME}/.vim/bundle/vundle
  echo "Installing other vim bundles"
  vim -N -u ${HOME}/.vim/config/bundles.vim +BundleInstall +quitall
}

function all {
  symlinks && \
    homebrew && \
    mac_defaults && \
    vim
}

[[ $@ == *'-symlinks'* ]] && symlinks()
[[ $@ == *'-homebrew'* ]] && homebrew()
[[ $@ == *'-mac_defaults'* ]] && mac_defaults()
[[ $@ == *'-vim'* ]] && vim()
[[ $@ == *'-all'* ]] && all()
