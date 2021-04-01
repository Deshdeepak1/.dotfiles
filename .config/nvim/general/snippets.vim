" SNIPPETS:

" Read an empty HTML template and move cursor to title
nnoremap ,html :-1read $HOME/.config/nvim/snippets/skeleton.html<CR>3jwf>a
nnoremap ,cl :-1read $HOME/.config/nvim/snippets/skeleton.c<CR>3ja<TAB>
nnoremap ,cpp  :-1read $HOME/.config/nvim/snippets/skeleton.cpp<CR>4ja<TAB>
