if [[ ${PWD} != ${HOME} ]]; then
  echo "Must be run from ${HOME}"
  exit 0
fi
if ! hash git >/dev/null 2>&1; then
  echo "Please install Git"
  exit 0
fi

echo "Creating symlinks..."
EXCLUDE="Avatar.jpg install.sh README.md tmux.conf.default \
         osx_defaults.sh default-dock.plist \
         Brewfile Pipfile Gemfile Gemfile.lock"
uname | grep -q Darwin && EXCLUDE="ls_colors ${EXCLUDE}"
LS=$(ls .dotfiles)
for f in ${LS}; do
  grep -q ${f} <<<"${EXCLUDE}" || ln -sf ${HOME}/.dotfiles/${f} ${HOME}/.${f}
done

if uname | grep -q Darwin; then
  echo "Mac: installing homebrew and brew/cask packages"
  echo "This will take a while!"
  git clone https://github.com/Homebrew/brew "${HOME}/brew" >/dev/null || true
  export PATH=$PATH:${HOME}/brew/bin
  brew tap Homebrew/bundle >/dev/null
  brew bundle --file=${HOME}/.dotfiles/Brewfile
  brew cleanup

  echo "Mac: setting some defaults"
  ${HOME}/.dotfiles/osx_defaults.sh
fi

echo "Installing eggs"
sudo easy_install pip
pip install -r "${HOME}/.dotfiles/Pipfile" -q

echo "Installing gems"
gem install bundler --user-install -q
bundle install --gemfile "${HOME}/.dotfiles/Gemfile" --quiet

echo "Installing latest vundle bundle"
rm -fr ${HOME}/.vim/bundle/vundle/* ${HOME}/.vim/bundle/vundle/.* 2>/dev/null
git clone https://github.com/gmarik/vundle.git ${HOME}/.vim/bundle/vundle
echo "Installing other vim bundles"
vim -N -u ${HOME}/.vim/config/bundles.vim +BundleInstall +quitall

echo "**********"
echo " Complete "
echo "**********"
