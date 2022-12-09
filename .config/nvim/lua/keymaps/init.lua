local opts = { noremap = true }
local keymap = vim.keymap.set

keymap("", "<SPACE>", "<Nop>", opts)
vim.g.mapleader = " "


-- Save  Quit
keymap("n", "<leader>q", ":close<CR>", opts)
keymap("n", "<leader>q", ":bdelete<CR>", opts)
-- keymap("n", "<leader>x", ":bdelete<CR>", opts)
keymap("n", "<leader>Q", ":quit<CR>", opts)
--keymap("n", "<leader>Q", ":quitall!<CR>", opts)
keymap("n", "<leader>S", ":luafile %<CR>", opts)
keymap("n", "<leader>s", ":update<CR>", opts)
--keymap("n", "<leader>sq", ":wq<CR>", opts)
keymap("n", "<leader>w", ":saveas<SPACE>", opts)
keymap("n", "<leader>W", ":write<SPACE>", opts)

-- Remap ESC
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

-- Splits
keymap("n", "<leader>h", ":split<SPACE>", opts)
keymap("n", "<leader>v", ":vsplit<SPACE>", opts)
keymap("n", "<C-h>", "<c-w>h", opts)
keymap("n", "<C-l>", "<c-w>l", opts)
keymap("n", "<C-j>", "<c-w>j", opts)
keymap("n", "<C-k>", "<c-w>k", opts)
keymap("n", "<M-h>", ":vertical resize -2<CR>", opts)
keymap("n", "<M-l>", ":vertical resize +2<CR>", opts)
keymap("n", "<M-j>", ":resize -2<CR>", opts)
keymap("n", "<M-k>", ":resize +2<CR>", opts)

-- Tabs
--keymap("n", "<leader>n", ":<SPACE>", opts)
--keymap("n", "<TAB>", ":tabnext<CR>", opts)
--keymap("n", "<S-TAB>", ":tabprevious<CR>", opts)

-- Buffer
keymap("n", "<leader>n", ":e<SPACE>", opts)
keymap("n", "<leader>b", ":b<SPACE>", opts)
keymap("n", "<TAB>", ":bnext<CR>", opts)
keymap("n", "<S-TAB>", ":bprevious<CR>", opts)

-- Ends
--keymap("", "gl", "$", opts) -- D, Y, C also works till end. dd, yy, cc works on line
--keymap("", "gh", "0", opts)

-- Sed
keymap("n", "<M-s>", ":%s///gI<Left><Left><Left><Left>", opts)
keymap("v", "<M-s>", ":s///gI<Left><Left><Left><Left>", opts)

-- Better Indentation
keymap("v", ">", ">gv", opts) -- C-T
keymap("v", "<", "<gv", opts) -- C-D

-- Arrows off
keymap("n", "<Up>", "<Nop>", opts)
keymap("n", "<Down>", "<Nop>", opts)
keymap("n", "<Left>", "<Nop>", opts)
keymap("n", "<Right>", "<Nop>", opts)

-- Change paste behaviour
keymap("v", "p", '"_dP', opts)
keymap("n", "cp", '"+', opts)
keymap("v", "cp", '"+', opts)

-- Move Lines up and down
keymap("v", "J", ":move '>+1<CR>gv-gv", opts) -- ddp for 1 line down
keymap("v", "K", ":move '<-2<CR>gv-gv", opts) -- ddkP for 1 line up

-- My Snippets
keymap("n", ",h", ":-1read $HOME/.config/nvim/snippets/skeleton.html<CR>3jwf>a", opts)
keymap("n", ",c", ":-1read $HOME/.config/nvim/snippets/skeleton.c<CR>3ja<TAB>", opts)
keymap("n", ",cc", ":-1read $HOME/.config/nvim/snippets/skeleton.cpp<CR>4ja<TAB>", opts)
keymap("n", ",cp", ":-1read $HOME/.config/nvim/snippets/skeleton_cp.cpp<CR>4ja<TAB>", opts)
keymap("n", ",p", ":-1read $HOME/.config/nvim/snippets/skeleton.py<CR>o<TAB>", opts)
keymap("n", ",pa", ":-1read $HOME/.config/nvim/snippets/skeleton_aio.py<CR>4ja<TAB>", opts)

vim.cmd [[ autocmd filetype cpp nnoremap <F5> :!g++ "%"  && ./a.out < input.txt > output.txt<CR> ]]
vim.cmd [[ autocmd filetype nroff nnoremap <F5> :!groff -ms -UT pdf "%" > $(basename "%" .ms).pdf<CR> ]]


-- Comment
keymap("n", "<leader>/", '<cmd>lua require"Comment.api".toggle.linewise()<cr>', opts)
keymap('x', '<leader>/', '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', opts)
