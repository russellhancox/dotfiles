" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif

" Clear the current search string (to remove highlighting..)
nmap <silent> <Leader>c :nohlsearch<CR>

command! -nargs=* -complete=file PEdit :!g4 edit %
command! -nargs=* -complete=file PRevert :!g4 revert %
command! -nargs=* -complete=file PDiff :!g4 diff %

" Locked file?
function! s:CheckOutFile()
 if filereadable(expand("%")) && ! filewritable(expand("%"))
   let s:pos = getpos('.')
   let s:p4info = system("p4 info > /dev/null 2>/dev/null")
   if v:shell_error < 1
     let option = confirm("Readonly file, do you want to checkout from p4?"
           \, "&Yes\n&No", 1, "Question")
     if option == 1
       PEdit
       edit!
       call cursor(s:pos[1:3])
     endif
   endif
 endif
endfunction
au FileChangedRO * nested :call <SID>CheckOutFile()
