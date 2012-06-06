nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

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

" Map Ctrl-T to delete the last path component when entering commands
cnoremap <C-t> <C-\>e(<SID>RemoveLastPathComponent())<CR>
function! s:RemoveLastPathComponent()
  let c = getcmdline()
  let cRoot = fnamemodify(c, ':r')
  return (c != cRoot ? cRoot : substitute(c, '\%(\\ \|[\\/]\@!\f\)\+[\\/]\=$\|.$', '', ''))
endfunction
