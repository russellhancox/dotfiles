" Load Vundle and other bundles
  source ~/.vim/config/bundles.vim
" NB: filetype plugin indent on is called at the end of that file

" Basic configuration
  syntax on

  set t_Co=256
  set background=dark
  silent! colorscheme tomorrow-night

  set autoindent                    " Auto indent new lines, brackets etc.
  set autoread                      " Reload files changed outside of VIM.
  set backspace=indent,eol,start    " Allow backspacing everywhere (i-mode)
  set nobackup                      " Don't leave backup files everywhere
  silent! set colorcolumn=80        " Leave a line down the screen at 80c
  set copyindent                    " Copy previous indentation when indenting
  set cursorline                    " Show a line where the cursor is
  set encoding=utf-8                " Default encoding
  set expandtab                     " Expand tabs to spaces
  set hidden                        " Allow moving to a different buffer
                                    " when the current one is not saved
  set history=1000                  " Keep 1000 lines of command history
  set hlsearch                      " Highlight search results
  set ignorecase                    " Ignore case when searching
  set incsearch                     " Search as soon as matches are found
  set laststatus=2                  " Show status line on penultimate line
  set modelines=0                   " Disable modelines
  set mouse=a                       " Enable mouse support
  set number                        " Show line number gutter
  set scrolloff=5                   " Keep cursor 5 lines from top/bottom
  set shortmess+=Ia                 " Hide/shorten certain messages
  set shortmess-=l                  " ^^^
  set showcmd                       " Display incomplete commands
  set noshowmode                    " Don't show mode on last line
  set smartcase                     " If search includes an uppercase character,
                                    " do a case-sensitive search
  set smarttab                      " Inserting tabs at start of line
  set ttyfast                       " Make text scrolling smoother
  set undolevels=1000               " Lots of undo
  set nowrap                        " Don't wrap long lines.

" Set tab width
  let g:tabwidth=2

  exec 'set shiftwidth='  . g:tabwidth
  exec 'set softtabstop=' . g:tabwidth
  exec 'set tabstop='     . g:tabwidth

" Persistent undo
  silent! !mkdir ~/.vim/backups > /dev/null 2>&1
  silent! set undodir=~/.vim/backups
  silent! set undofile

" Wildmenu
  set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*DS_Store*
  set wildignore+=*.swp,*.jpg,*.png,*.xpm,*.gif,*.pyc,*/.tox/*,*.egg-info/*
  set wildmenu
  set wildmode=list:longest,full

" Set PowerLine options
  silent! let g:Powerline_symbols = 'compatible'
  silent! let g:Powerline_stl_path_style = 'short'

" Resize Vim windows when available size changes
  autocmd VimResized * wincmd =

" Process other configs
  runtime! config/*.vim

  if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
  endif
