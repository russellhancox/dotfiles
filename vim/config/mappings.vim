" Map Control + {h, j, k, l} to move windows
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

" Map ,e to edit a file in the current working directory
nmap <silent> ,e :e <C-R>=expand("%:p:h") . "/" <CR>

" Map ,cd to change cwd to the directory of the file currently being edited
nmap <silent> ,cd :cd %:p:h <CR>

" Map <Leader>t to NERDTreeToggle (keeping window selection)
nmap <silent> <Leader>t :NERDTreeToggle<CR> :wincmd p<CR>

" Map <Leader>... to …
imap <silent> <Leader>... …

" Wean off the arrow keys, young padawan.
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" Ctrl-P to toggle paste mode
set pastetoggle=<C-P>

" Map Ctrl-T to delete the last path component when entering commands
cnoremap <C-t> <C-\>e(<SID>RemoveLastPathComponent())<CR>
function! s:RemoveLastPathComponent()
  let c = getcmdline()
  let cRoot = fnamemodify(c, ':r')
  return (c != cRoot ? cRoot : substitute(c, '\%(\\ \|[\\/]\@!\f\)\+[\\/]\=$\|.$', '', ''))
endfunction
