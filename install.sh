#!/bin/bash

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
  INCLUDE="zshrc gitconfig gitignore vim vimrc tmux.conf hammerspoon"
  for f in ${INCLUDE}; do
    echo "Symlinking ${HOME}/.dotfiles/${f} to ${HOME}/.${f}"
    ln -sf ${HOME}/.dotfiles/${f} ${HOME}/.${f}
  done
}

function mac_defaults {
  if uname | grep -q Darwin; then
    echo "Mac: setting some defaults"
    ${HOME}/.dotfiles/osx_defaults.sh
  fi
}

function vim_settings {
  echo "Installing Vim plugins"
  vim -N -u ${HOME}/.vim/config/bundles.vim +PlugInstall! +quitall
}

function all {
  symlinks && \
    mac_defaults && \
    vim_settings
}

[[ "${@}" == *-symlinks* ]] && symlinks
[[ "${@}" == *'-mac_defaults'* ]] && mac_defaults
[[ "${@}" == *'-vim'* ]] && vim_settings
[[ "${@}" == *'-all'* ]] && all
