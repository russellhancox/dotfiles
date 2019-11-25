" For Makefiles highlighting tabs is annoying
autocmd BufRead,BufNewFile *.make setl filetype=make
autocmd filetype html,xml,make,go setl nolist
autocmd filetype html,xml,make,go setl noexpandtab

" Associate .mm files as Objective-C++
autocmd BufRead,BufNewFile *.mm setl filetype=objcpp

" I like 2 spaces in Python files
autocmd FileType python setl sw=2 sts=2 et
