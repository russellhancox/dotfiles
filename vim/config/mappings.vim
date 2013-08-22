" Map ; to : to save typing
nnoremap ; :

" Map Control + {h, j, k, l} to move windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Map ,e to edit a file in the current working directory
nmap <silent> <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Map ,cd to change cwd to the directory of the file currently being edited
nmap <silent> <Leader>cd :cd %:p:h <CR>

" Map <Leader>... to …
imap <silent> <Leader>... …

" Map ' to toggle TagBar
noremap ' :TagbarToggle<CR>

" Remap <F1> to Escape. I didn't want to see help anyway.
map <F1> <Esc>
imap <F1> <Esc>

" Leader P to toggle paste mode
set pastetoggle=<Leader>p

" Mappings for Mac pbcopy
if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    vmap <C-x> :!pbcopy<CR>
    vmap <C-c> :w !pbcopy<CR><CR>
  endif
endif

" Mappings to move and remove color column. The default is 80
command! C100 :set colorcolumn=100
command! C80 :set colorcolumn=80
command! C0 :set colorcolumn=0

" Map w!! to sudo save
command! SudoWrite set noro | w !sudo tee % >/dev/null
cmap w!! SudoWrite<CR>

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif

" Clear the current search string (to remove highlighting..)
nmap <silent> <Leader>c :nohlsearch<CR>
