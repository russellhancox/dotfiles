" Load Vundle and other bundles
  source ~/.vim/config/bundles.vim

" Basic configuration
  syntax on
  set t_Co=256

  silent! colorscheme solarized

  set autoindent
  set backspace=indent,eol,start    " Allow backspacing everywhere (i-mode)
  set nobackup                      " Don't leave backup files everywhere
  silent! set colorcolumn=80        " Leave a line down the screen at 80c
  set encoding=utf-8
  set expandtab                     " Expand tabs to spaces
  set hidden                        " Allow moving to a different buffer
                                    " when the current one is not saved
  set history=50                    " Keep 50 lines of command history
  set hlsearch                      " Highlight search results
  set ignorecase
  set incsearch                     " Begin searching as soon as matches are
                                    " found
  set laststatus=2                  " Show status line on penultimate line
  set number                        " Show line number gutter
  set shortmess+=Ia                 " Hide/shorten certain messages
  set shortmess-=l
  set showcmd                       " Display incomplete commands
  set noshowmode                    " Don't show mode on last line
  set smarttab                      " Inserting tabs at start of line
  set nowrap                        " Don't wrap long lines

" Set tab width
  let g:tabwidth=2

  exec 'set shiftwidth='  . g:tabwidth
  exec 'set softtabstop=' . g:tabwidth
  exec 'set tabstop='     . g:tabwidth

" Wildmenu
  set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj
  set wildignore+=*.swp,*.jpg,*.png,*.xpm,*.gif,*.pyc,*/.tox/*,*.egg-info/*
  set wildmenu
  set wildmode=list:longest,full


" Process other configs
  runtime! config/*.vim

  if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
  endif
