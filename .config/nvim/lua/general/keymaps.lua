local opts = { noremap = true }
local sopts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

keymap("", "<SPACE>", "<Nop>", opts)
vim.g.mapleader = " "

-- Save  Quit
keymap("n", "<leader>q", ":quit<CR>", opts)
keymap("n", "<leader>Q", ":quitall!<CR>", opts)
keymap("n", "<leader>s", ":update<CR>", opts)
keymap("n", "<leader>sq", ":wq<CR>", opts)
keymap("n", "<leader>w", ":saveas<SPACE>", opts)
keymap("n", "<leader>W", ":write<SPACE>", opts)

-- Remap ESC
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

-- Clipboard
keymap("n", "cp", '"+', opts)
keymap("v", "cp", '"+', opts)

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
keymap("n", "<leader>n", ":tabnew<SPACE>", opts)
keymap("n", "<TAB>", ":tabnext<CR>", opts)
keymap("n", "<S-TAB>", ":tabprevious<CR>", opts)

-- Ends
keymap("", "gl", "$", opts) -- D, Y, C also works till end. dd, yy, cc works on line
keymap("", "gh", "0", opts)

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

-- Move Lines up and down
keymap("v", "J", ":move '>+1<CR>gv-gv", opts) -- ddp for 1 line down
keymap("v", "K", ":move '<-2<CR>gv-gv", opts) -- ddkP for 1 line up

-- Explorer
keymap("n", "<leader>e", ":Lexp 20<CR>", opts)

vim.cmd [[ autocmd filetype cpp nnoremap <F5> :!g++ "%"  && ./a.out < input.txt > output.txt<CR> ]]
vim.cmd [[ autocmd filetype nroff nnoremap <F5> :!groff -ms -UT pdf "%" > $(basename "%" .ms).pdf<CR> ]]

-- Telescope
keymap("n", "<C-f>", "<cmd>Telescope find_files<cr>", opts)
-- keymap("n", "<leader>f", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<C-t>", "<cmd>Telescope live_grep<cr>", opts)

-- Comment
keymap("n", "<leader>/", '<cmd>lua require"Comment.api".toggle_linewise_op()<cr>', opts)
keymap('x', '<leader>/', '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>', opts)

-- Session
keymap("n", "<C-s>", "<cmd>lua MiniSessions.select()<CR>", opts)
keymap("n", "<leader>S", ":SaveSession<Space>", opts)
keymap("n", "<leader>D", ":DeleteSession<Space>", opts)

-- Illuminate
-- keymap('n', '<a-n>', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', opts)
-- keymap('n', '<a-p>', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', opts)

-- My Snippets
keymap("n", ",html", ":-1read $HOME/.config/nvim/snippets/skeleton.html<CR>3jwf>a", opts)
keymap("n", ",cl", ":-1read $HOME/.config/nvim/snippets/skeleton.c<CR>3ja<TAB>", opts)
keymap("n", ",cpp", ":-1read $HOME/.config/nvim/snippets/skeleton.cpp<CR>4ja<TAB>", opts)
keymap("n", ",cpf", ":-1read $HOME/.config/nvim/snippets/cp.cpp<CR>4ja<TAB>", opts)
