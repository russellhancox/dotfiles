[[ ${PWD} != ${HOME} ]] && (echo "Must be run from ${HOME}" && exit 0)
hash git >/dev/null 2>&1 || (echo "Please install Git" && exit 0)

echo "Creating symlinks..."
EXCLUDE="install.sh README.md solarized_dark.terminal"
LS=`ls .dotfiles`
for x in ${EXCLUDE}; do
  LS=`echo ${LS} | grep -v ${x}`;
done
for f in `${LS}`; do 
  ln -s ${HOME}/.dotfiles/${f} ${HOME}/.${f} >/dev/null 2>&1;
done

if [[ ! -f "${HOME}/vim/bundle/vundle/README.md" ]]; then
  echo "Installing latest vundle bundle"
  rm -fr ${HOME}/.vim/bundle/vundle/* ${HOME}/.vim/bundle/vundle/.*
  git clone https://github.com/gmarik/vundle.git ${HOME}/.vim/bundle/vundle
  echo "Installing other bundles"
  vim -N -u ${HOME}/.vim/config/bundles.vim +BundleInstall +quitall
  echo "Building Command-T bundle"
  pushd .
  cd ${HOME}/.vim/bundle/Command-T/ruby/command-t
  ruby extconf.rb
  make
  popd
else
  echo "Skipping vundle download"
fi

echo "Complete"
