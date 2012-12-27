" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif

" Clear the current search string (to remove highlighting..)
nmap <silent> <Leader>c :nohlsearch<CR>

command! -nargs=* -complete=file PEdit :!p4 edit %
command! -nargs=* -complete=file PRevert :!p4 revert %
command! -nargs=* -complete=file PDiff :!p4 diff %
