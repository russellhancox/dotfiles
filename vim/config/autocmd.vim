" If .vimrc is modified, automatically source it!
au! BufWritePost .vimrc |
  \ source % |
  \ if exists('g:Powerline_loaded') |
  \ silent! call Pl#Load() |
  \ endif

" If NERDTree is the only remaining window, close VIM
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Jump to last cursor position when opening a file
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
  if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
  endif
endfunction
