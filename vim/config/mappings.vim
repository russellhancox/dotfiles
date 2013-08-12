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

" Map w!! to sudo save
cmap w!! w !sudo tee % >/dev/null

" Mappings for Mac pbcopy
if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    vmap <C-x> :!pbcopy<CR>
    vmap <C-c> :w !pbcopy<CR><CR>
  endif
endif
