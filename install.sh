[[ $PWD != $HOME ]] && echo "Must be run from $HOME" && exit 0

for f in `ls .dotfiles | grep -v install.sh`; do ln -s ~/.dotfiles/$f ~/.$f; done
