filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Plugin manager
Plugin 'gmarik/vundle'

" Show Git status on left of screen.
Plugin 'airblade/vim-gitgutter'

" Ctrl+P: file, MRU and buffer search.
Plugin 'ctrlpvim/ctrlp.vim'

" EasyMotion, use <Leader><Leader>s and replace search
Plugin 'easymotion/vim-easymotion'

" Rainbow parens
Plugin 'junegunn/rainbow_parentheses.vim'

" Startup screen
Plugin 'mhinz/vim-startify'

" Colorscheme
Plugin 'Pychimp/vim-luna'

" Puppet syntax/highlighting
Plugin 'rodjek/vim-puppet'

" File browser
Plugin 'scrooloose/nerdtree'

" Show syntax errors upon save.
Plugin 'scrooloose/syntastic'

" Typing 'ga' over a character reveals representation
" in unicode, HTML, etc.
Plugin 'tpope/vim-characterize'

" Sensible VIM defaults. Like nocompatible mode on steroids.
Plugin 'tpope/vim-sensible'

" The nice bar at the bottom.
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

filetype plugin indent on
