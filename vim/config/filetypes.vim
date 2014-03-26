" For Go files, run gofmt after writing
autocmd filetype go autocmd BufWritePre <buffer> Fmt

" For certain filetypes highlighting tabs is annoying highlighting is annoying
autocmd BufRead,BufNewFile *.make set filetype=make
autocmd filetype html,xml,make,go set nolist
autocmd filetype html,xml,make,go set noexpandtab

