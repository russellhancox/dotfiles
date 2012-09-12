" Highlight certain chars:
set list

" Highlight tabs with >.
set listchars=tab:>.

" Highlight trailing whitespace and nbsp with .
set listchars+=trail:.
set listchars+=nbsp:.

" Highlight lines that extend off-screen with #
set listchars+=extends:#

" For certain filetypes, tab is OK
autocmd filetype html,xml,make set listchars-=tab:>.
