" If .vimrc is modified, automatically source it!
au! BufWritePost .vimrc |
  \ source % |
  \ if exists('g:Powerline_loaded') |
  \ silent! call Pl#Load() |
  \ endif
