" Map ; to : to save my pinky.
nnoremap ; :

" Map ,cd to change cwd to the directory of the file currently being edited
nmap <silent> <leader>cd :cd %:p:h <CR>

" Map <Leader>... to …
imap <silent> <leader>... …

" Map <Leader>P to toggle paste mode
set pastetoggle=<Leader>p

" Map <C-L> (redraw screen) to also turn off search highlighting until the next search
nnoremap <C-L> :nohl<CR><C-L>

" Remap <F1> to Escape. I didn't want to see help anyway.
map <F1> <Esc>
imap <F1> <Esc>

" Mappings for Mac pbcopy
if has("osx")
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif

" Mappings to move and remove color column. The default is 80
command! C100 :set colorcolumn=100
command! C80 :set colorcolumn=80
command! C0 :set colorcolumn=0

" Map w!! to sudo save
command! SudoWrite set noro | w !sudo tee % >/dev/null
cmap w!! SudoWrite<CR><CR>

" In case I fat-finger W/Wq.
command! W write
command! Wq wq

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif

" Use <Tab> to move between bracket pairs
nnoremap <tab> %
vnoremap <tab> %

" Use vdd (void delete) to delete without copy
nnoremap vd "_d

" Toggle NERDTree with Ctrl+N and close vim if NERDTree is left as only
" remaining window.
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

