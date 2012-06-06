" If .vimrc is modified, automatically source it!
au! BufWritePost .vimrc |
  \ source % |
  \ if exists('g:Powerline_loaded') |
  \ silent! call Pl#Load() |
  \ endif

" If NERDTree is the only remaining window, close VIM
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
