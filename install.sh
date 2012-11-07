[[ ${PWD} != ${HOME} ]] && (echo "Must be run from ${HOME}" && exit 0)
hash git >/dev/null 2>&1 || (echo "Please install Git" && exit 0)

echo "Updating submodules"
git submodule init
git submodule update

echo "Creating symlinks..."
EXCLUDE="install.sh README.md solarized_dark.terminal"
LS=`ls .dotfiles`
for x in ${EXCLUDE}; do
  LS=`echo ${LS} | grep -v ${x}`;
done
for f in `${LS}`; do 
  ln -s ${HOME}/.dotfiles/${f} ${HOME}/.${f} >/dev/null 2>&1;
done

echo "Installing latest vundle bundle"
rm -fr ${HOME}/.vim/bundle/vundle/* ${HOME}/.vim/bundle/vundle/.* 2>/dev/null
git clone https://github.com/gmarik/vundle.git ${HOME}/.vim/bundle/vundle
echo "Installing other vim bundles"
vim -N -u ${HOME}/.vim/config/bundles.vim +BundleInstall +quitall
echo "Building Command-T bundle"
pushd .
cd ${HOME}/.vim/bundle/Command-T/ruby/command-t
ruby extconf.rb
make
popd

# If running on a Mac, set-up Mac defaults..
if uname | grep -q Darwin; then
  echo "Running on a Mac, setting Mac defaults"
  ${HOME}/.dotfiles/osx_defaults.sh
fi

echo "Complete"
