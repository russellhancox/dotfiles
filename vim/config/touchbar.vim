autocmd VimEnter * silent !echo -ne "\033[1337;PushKeyLabels=vim\a"

autocmd VimEnter * silent !echo -ne "\033]1337;SetKeyLabel=F1=Save & Quit\a"
autocmd VimEnter * map <F1> :wq<CR>
autocmd VimEnter * silent !echo -ne "\033]1337;SetKeyLabel=F2=Quit\a"
autocmd VimEnter * map <F2> :q!<CR>
autocmd VimEnter * silent !echo -ne "\033]1337;SetKeyLabel=F3=Toggle Paste\a"
autocmd VimEnter * map <F3> :set paste!<CR>

autocmd VimLeave * silent !echo -ne "\033]1337;PopKeyLabels=vim\a"
