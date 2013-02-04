if [[ ${PWD} != ${HOME} ]]; then
  echo "Must be run from ${HOME}"
  exit 0
fi
if ! hash git >/dev/null 2>&1; then
  echo "Please install Git"
  exit 0
fi

echo "Creating symlinks..."
EXCLUDE="install.sh README.md solarized_dark.terminal tmux.conf.default \
         tmuxpowerline osx_defaults.sh"
LS=$(ls .dotfiles)
for f in ${LS}; do
  echo "${EXCLUDE}" | grep -q ${f} || \
      ln -s ${HOME}/.dotfiles/${f} ${HOME}/.${f} >/dev/null 2>&1
done

echo "Installing latest vundle bundle"
rm -fr ${HOME}/.vim/bundle/vundle/* ${HOME}/.vim/bundle/vundle/.* 2>/dev/null
git clone https://github.com/gmarik/vundle.git ${HOME}/.vim/bundle/vundle
echo "Installing other vim bundles"
vim -N -u ${HOME}/.vim/config/bundles.vim +BundleInstall +quitall

# If running on a Mac, set-up Mac defaults..
if uname | grep -q Darwin; then
  echo "Running on a Mac, setting Mac defaults"
  ${HOME}/.dotfiles/osx_defaults.sh
fi

echo "Complete"
