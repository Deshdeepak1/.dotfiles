#Codi
function codi
   nvim -c \
     "let g:startify_disable_at_vimenter = 1 |\
     hi CodiVirtualText guifg=cyan
     Codi python" "$argv"
end
