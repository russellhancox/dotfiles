" For Go files, run gofmt after writing
autocmd filetype go autocmd BufWritePre <buffer> Fmt

" For certain filetypes highlighting tabs is annoying highlighting is annoying
autocmd BufRead,BufNewFile *.make setl filetype=make
autocmd filetype html,xml,make,go setl nolist
autocmd filetype html,xml,make,go setl noexpandtab
autocmd FileType python setl sw=2 sts=2 et
