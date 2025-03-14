" Load Plug and other bundles
  source ~/.vim/config/bundles.vim

  colorscheme catppuccin_mocha

  set nobackup                      " Don't leave backup files everywhere
  silent! set colorcolumn=80        " Leave a line down the screen at 80c
  set copyindent                    " Copy previous indentation when indenting
  set cursorline                    " Show a line where the cursor is
  set encoding=utf-8                " Default encoding
  set expandtab                     " Expand tabs to spaces
  set hidden                        " Allow moving to a different buffer
                                    " when the current one is not saved
  set hlsearch                      " Highlight search results
  set ignorecase                    " Ignore case when searching
  set modelines=0                   " Disable modelines
  set mouse=a                       " Enable mouse support
  set number                        " Show line number gutter
  set scrolloff=5                   " Keep cursor 5 lines from top/bottom
  set shortmess+=Ia                 " Hide/shorten certain messages
  set shortmess-=l                  " ^^^
  set noshowmode                    " Don't show mode on last line
  set smartcase                     " If search includes an uppercase character
                                    " do a case-sensitive search
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

" Resize Vim windows when available size changes
  autocmd VimResized * wincmd =

" Process other configs
  runtime! config/*.vim

  if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
  endif
