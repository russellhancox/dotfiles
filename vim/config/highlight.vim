" Highlight certain chars:
set list

" Highlight tabs with »·
set listchars=tab:»·

" Highlight trailing whitespace and nbsp with ·
set listchars+=trail:·
set listchars+=nbsp:·

" Highlight lines that extend off-screen with #
set listchars+=extends:#

" Use rainbow highlighting for parentheses
au VimEnter * RainbowParentheses
