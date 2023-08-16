local opts = { noremap = true }
local keymap = vim.keymap.set

-- keymap("", "<SPACE>", "<Nop>", opts)
vim.g.mapleader = " "


-- Save  Quit
-- keymap("n", "<leader>q", ":close<CR>", { desc = "CloseBuffer" })
keymap("n", "<leader>q", ":bdelete<CR>", { desc = "CloseBuffer" })
-- keymap("n", "<leader>x", ":bdelete<CR>", opts)
keymap("n", "<leader>qq", ":quit<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", ":quitall!<CR>", { desc = "QuitAll" })
keymap("n", "<leader>w", ":update<CR>", { desc = "Save" })
keymap("n", "<leader>S", ":luafile %<CR>", { desc = "Source" })
keymap("n", "<leader>wq", ":wq<CR>", { desc = "Save&Quit" })
-- keymap("n", "<leader>s", ":saveas<SPACE>", { desc = "SaveAs" })
keymap("n", "<leader>W", ":write<SPACE>", { desc = "SaveTo" })

-- Remap ESC
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

-- Center Screen
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")


-- Splits
keymap("n", "<leader>H", ":split<SPACE>", { desc = "Split" })
keymap("n", "<leader>v", ":vsplit<SPACE>", { desc = "VSplit" })
keymap("n", "<C-h>", "<c-w>h", opts)
keymap("n", "<C-j>", "<c-w>j", opts)
keymap("n", "<C-k>", "<c-w>k", opts)
keymap("n", "<C-l>", "<c-w>l", opts)
keymap("n", "<M-h>", ":vertical resize -2<CR>", opts)
keymap("n", "<M-l>", ":vertical resize +2<CR>", opts)
keymap("n", "<M-j>", ":resize -2<CR>", opts)
keymap("n", "<M-k>", ":resize +2<CR>", opts)

-- Tabs
--keymap("n", "<leader>n", ":<SPACE>", opts)
--keymap("n", "<TAB>", ":tabnext<CR>", opts)
--keymap("n", "<S-TAB>", ":tabprevious<CR>", opts)

-- Buffer
keymap("n", "<leader>n", ":e<SPACE>", { desc = "Edit" })
keymap("n", "<leader>bb", ":b<SPACE>", { desc = "Buffers" })
keymap("n", "<TAB>", ":bnext<CR>", opts)
keymap("n", "<S-TAB>", ":bprevious<CR>", opts)

-- Sed
keymap("n", "<M-s>", ":%s///gI<Left><Left><Left><Left>", opts)
keymap("v", "<M-s>", ":s///gI<Left><Left><Left><Left>", opts)
keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "RepCurWord" })


-- Better Indentation
keymap("v", ">", ">gv", opts) -- C-T
keymap("v", "<", "<gv", opts) -- C-D

-- Arrows off
-- keymap("n", "<Up>", "<Nop>", opts)
-- keymap("n", "<Down>", "<Nop>", opts)
-- keymap("n", "<Left>", "<Nop>", opts)
-- keymap("n", "<Right>", "<Nop>", opts)

-- Change paste behaviour
-- keymap("v", "p", '"_dP', opts)
keymap("x", "<leader>p", [["_dP]], { desc = "PrevPaste" })
keymap("n", "cp", '"+', opts)
keymap({ "n", "v" }, "<leader>y", '"+y', { desc = "C2C" })
keymap("n", "<leader>Y", '"+Y', { desc = "C2C2End" })

-- Move Lines up and down
keymap("n", "J", "mzJ`z")
keymap("v", "J", ":move '>+1<CR>gv=gv", opts) -- ddp for 1 line down
keymap("v", "K", ":move '<-2<CR>gv=gv", opts) -- ddkP for 1 line up

-- New Lines
keymap("n", "zj", ':<C-u>call append(line("."),   repeat([""], v:count1))<CR>', { desc = "New Line below" })
keymap("n", "zk", ':<C-u>call append(line(".")-1,   repeat([""], v:count1))<CR>', { desc = "New Line above" })

-- Quick Fix List
keymap("n", "<leader>cj", "<cmd>cprev<CR>zz", { desc = "Prev" })
keymap("n", "<leader>ck", "<cmd>cnext<CR>zz", { desc = "Next" })
-- My Snippets
keymap("n", ",h", ":-1read $HOME/.config/nvim/snippets/skeleton.html<CR>3jwf>a", opts)
keymap("n", ",c", ":-1read $HOME/.config/nvim/snippets/skeleton.c<CR>3ja<TAB>", opts)
keymap("n", ",cc", ":-1read $HOME/.config/nvim/snippets/skeleton.cpp<CR>4ja<TAB>", opts)
keymap("n", ",cp", ":-1read $HOME/.config/nvim/snippets/skeleton_cp.cpp<CR>4ja<TAB>", opts)
keymap("n", ",p", ":-1read $HOME/.config/nvim/snippets/skeleton.py<CR>o<TAB>", opts)
keymap("n", ",pa", ":-1read $HOME/.config/nvim/snippets/skeleton_aio.py<CR>4ja<TAB>", opts)

vim.cmd [[ autocmd filetype cpp nnoremap <F5> :!g++ "%"  && ./a.out < input.txt > output.txt<CR> ]]
vim.cmd [[ autocmd filetype nroff nnoremap <F5> :!groff -ms -UT pdf "%" > $(basename "%" .ms).pdf<CR> ]]


-- Netrw
keymap("n", "<leader>E", ":20Lexplore!<CR>", { desc = "Netrw" })
-- :20Lexplore! -- Open on right side

-- keymap("n", "<leader>H", ":help<SPACE>", opts)
