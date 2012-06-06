[[ ${PWD} != ${HOME} ]] && (echo "Must be run from ${HOME}" && exit 0)
hash git >/dev/null 2>&1 || (echo "Please install Git" && exit 0)

echo "Creating symlinks..."
for f in `ls .dotfiles | grep -v install.sh | grep -v README.md`; do 
  ln -s ${HOME}/.dotfiles/$f ~/.$f >/dev/null 2>&1; 
done

if [[ ! -f "${HOME}/vim/bundle/vundle/README.md" ]]; then
  echo "Installing latest vundle plugin"
  rm -fr ${HOME}/.vim/bundle/vundle/* ${HOME}/.vim/bundle/vundle/.*
  git clone https://github.com/gmarik/vundle.git ${HOME}/.vim/bundle/vundle
else
  echo "Skipping vundle download"
fi

echo "========================================================="
echo "Installed.."
echo ""
echo "Launching Vim to install bundles. Once the install has"
echo "finished, use :qa to return back to prompt"
echo ""
echo "Press any key to continue"
echo "========================================================="

read

vim -c BundleInstall
