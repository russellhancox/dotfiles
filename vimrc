set nocompatible	        " be iMproved
filetype off                    " required for Vundle

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'Lokaltog/vim-powerline'
Bundle 'Lokaltog/vim-distinguished'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdtree'

filetype plugin indent on       " Detect filetypes and do auto-indentation

set t_Co=256
set term=screen-256color
let g:Powerline_symbols = 'fancy'
call Pl#Theme#InsertSegment('ws_marker', 'after', 'lineinfo')

set backspace=indent,eol,start	" Allow backspacing over everything in insert mode

set encoding=utf-8
set history=50			" Keep 50 lines of command line history
set ruler       		" Show the cursor position all the time
set number			" Can't _not_ have line numbers..
set ignorecase			" Ignore case...
set smartcase			" ...intelligently
set showcmd			" Display incomplete commands
set showmode                    " Show mode down the bottom
set incsearch			" Do incremental searching
set showcmd			" Shows what you are typing as a command
set autoindent			" AutoIndent?
set expandtab			" No tabs
set smarttab			" NO TABS
set shiftwidth=2		" 2 spaces, instead..
set softtabstop=2		" Yep, 2 spaces
set colorcolumn=80              " Leave a line down the screen at 80 chars

" If .vimrc is modified, automatically source it!
au! BufWritePost .vimrc |
  \ source % |
  \ if exists('g:Powerline_loaded') |
  \ silent! call Pl#Load() |
  \ endif

" If NERDTree is the only remaining window, close VIM
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

if has('mouse')
  set mouse=a			" Who doesn't have a mouse?
endif

" Use English for spell checking, but don't spell check by default
if version >= 700
  set spl=en spell
  set nospell
endif

if &t_Co > 2 || has("gui_running")
  colorscheme distinguished
  syntax on			" Enable syntax highlighting
  set hlsearch			" Enable highlighted search
endif

" Detect file type and load indent files.
filetype plugin indent on

set wildmenu
set wildmode=list:longest,full

" Highlight matching paren
highlight Matchparen ctermbg=4

" Always show the status line just above the command line
set laststatus=2

" Set the status line format (description at the side)
"hi User1 ctermbg=red ctermfg=white
"hi User2 ctermbg=white ctermfg=blue
"set statusline=
"set statusline=%1*                                                " User Color 1
"set statusline+=\ %f\ \                                           " _${Filename as typed}__
"set statusline+=%2*                                               " User Color 2
"set statusline+=\ [%Y,\ %{&ff},\ %{strlen(&fenc)?&fenc:'none'}]\  "_[${File Type}, ${File Format}, ${File Encoding}]_
"set statusline+=%m                                                " ${Modified flag}
"set statusline+=%r                                                " ${Read only flag}
"set statusline+=%=                                                " Left/right separator
"set statusline+=%1*                                               " User Color 1
"set statusline+=\ %c,\                                            " _${Cursor column},_
"set statusline+=%l/%L                                             " ${Cursor line}/${total lines}
"set statusline+=\ %P\                                             " _${Percent through file}_

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Map Ctrl-T to delete the last path component when entering commands
cnoremap <C-t> <C-\>e(<SID>RemoveLastPathComponent())<CR>
function! s:RemoveLastPathComponent()
  let c = getcmdline()
  let cRoot = fnamemodify(c, ':r')
  return (c != cRoot ? cRoot : substitute(c, '\%(\\ \|[\\/]\@!\f\)\+[\\/]\=$\|.$', '', ''))
endfunction

" Map ,e to edit a file in the current working directory
map ,e :e <C-R>=expand("%:p:h") . "/" <CR>

" Map ,cd to change cwd to the directory of the file currently being edited
map ,cd :cd %:p:h <CR>

" Wean off the arrow keys, young padawan.
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" Ctrl-P to toggle paste mode
set pastetoggle=<C-P>

" Jump to last cursor position when opening a file
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
  if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
  endif
endfunction

" Attempt to read a local .vimrc file, if it exists
if filereadable(glob("~/.vimrc.local"))
  source ~/.vimrc.local
endif
