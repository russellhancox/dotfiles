let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

" Show Git status on left of screen.
Plug 'airblade/vim-gitgutter'

" Ctrl+P: file, MRU and buffer search.
Plug 'ctrlpvim/ctrlp.vim'

" EasyMotion, use <Leader><Leader>s and replace search
Plug 'easymotion/vim-easymotion'

" Rainbow parens
Plug 'junegunn/rainbow_parentheses.vim'

" Startup screen
Plug 'mhinz/vim-startify'

" Colorscheme
Plug 'Pychimp/vim-luna'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

" File browser
Plug 'scrooloose/nerdtree'

" Show syntax errors upon save.
Plug 'scrooloose/syntastic'

" Typing 'ga' over a character reveals representation
" in unicode, HTML, etc.
Plug 'tpope/vim-characterize'

" Sensible VIM defaults. Like nocompatible mode on steroids.
Plug 'tpope/vim-sensible'

" The nice bar at the bottom.
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()
