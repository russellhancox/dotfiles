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

  for f in ${HOME}/.dotfiles/config/*; do
    echo "Symlinking ${HOME}/.dotfiles/config/${f} to ${HOME}/.config/${f}"
    ln -sf ${HOME}/.dotfiles/config/${f} ${HOME}/.config/${f}
  done
}

function mac_defaults {
  if uname | grep -q Darwin; then
    echo "Mac: setting some defaults"
    ${HOME}/.dotfiles/osx_defaults.sh
  fi
}

function all {
  symlinks && \
    mac_defaults && \
}

[[ "${@}" == *-symlinks* ]] && symlinks
[[ "${@}" == *'-mac_defaults'* ]] && mac_defaults
[[ "${@}" == *'-all'* ]] && all
