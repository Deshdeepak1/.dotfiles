local opts = { noremap = true }
local keymap = vim.keymap.set

vim.g.mapleader = " "

-- Save  Quit
keymap("n", "<leader>q", ":bdelete<CR>", { desc = "CloseBuffer" })
-- keymap("n", "<leader>x", ":bdelete<CR>", opts)
keymap("n", "<leader>Q", ":quitall!<CR>", { desc = "QuitAll" })
keymap("n", "<leader>S", ":luafile %<CR>", { desc = "Source" })

-- wrap toggle
keymap("n", "<leader>w", function()
    vim.bo.wrap = not vim.bo.wrap
end, { desc = "WrapToggle" })

-- spell toggle
keymap("n", "<leader>s", function()
    vim.wo.spell = not vim.wo.spell
end, { desc = "SpellToggle" })

-- Remap ESC
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Center Screen
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- Resize Splits
keymap("n", "<M-h>", ":vertical resize -2<CR>", opts)
keymap("n", "<M-l>", ":vertical resize +2<CR>", opts)
keymap("n", "<M-j>", ":resize -2<CR>", opts)
keymap("n", "<M-k>", ":resize +2<CR>", opts)

-- Buffer
keymap("n", "<leader>bb", ":b<SPACE>", { desc = "Buffers" })
keymap("n", "<TAB>", ":bnext<CR>", opts)
keymap("n", "<S-TAB>", ":bprevious<CR>", opts)

-- Sed like subsitutions
keymap("n", "<M-s>", ":%s///gI<Left><Left><Left><Left>", opts)
keymap("v", "<M-s>", ":s///gI<Left><Left><Left><Left>", opts)
keymap("n", "<C-s>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "RepCurWord" })

-- Better Indentation
keymap("v", ">", ">gv", opts)
keymap("v", "<", "<gv", opts)


-- Change paste behaviour
-- keymap("v", "p", '"_dP', opts)
keymap("x", "<leader>p", [["_dP]], { desc = "PrevPaste" })
keymap("n", "cp", '"+', opts)
keymap({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy2Clipboard" })
keymap("n", "<leader>Y", '"+Y', { desc = "Copy2Clipboard2End", remap = true })

-- Join lines without cursor movement
keymap("n", "J", "mzJ`z")

-- Move Lines up and down
keymap("v", "J", ":move '>+1<CR>gv=gv", opts) -- ddp for 1 line down
keymap("v", "K", ":move '<-2<CR>gv=gv", opts) -- ddkP for 1 line up

-- New Lines
keymap("n", "zj", ':<C-u>call append(line("."),   repeat([""], v:count1))<CR>', { desc = "New Line below" })
keymap("n", "zk", ':<C-u>call append(line(".")-1,   repeat([""], v:count1))<CR>', { desc = "New Line above" })

-- Quick Fix List
keymap("n", "<leader>cj", "<cmd>cprev<CR>zz", { desc = "Prev" }) -- TODO: switch to c-j, c-k
keymap("n", "<leader>ck", "<cmd>cnext<CR>zz", { desc = "Next" })

-- TODO: , and  ; for f, F, t, T
-- My Snippets
-- keymap("n", ",h", ":-1read $HOME/.config/nvim/snippets/skeleton.html<CR>3jwf>a", opts)
-- keymap("n", ",c", ":-1read $HOME/.config/nvim/snippets/skeleton.c<CR>3ja<TAB>", opts)
-- keymap("n", ",cc", ":-1read $HOME/.config/nvim/snippets/skeleton.cpp<CR>4ja<TAB>", opts)
-- keymap("n", ",cp", ":-1read $HOME/.config/nvim/snippets/skeleton_cp.cpp<CR>5ja<TAB>", opts)
-- keymap("n", ",p", ":-1read $HOME/.config/nvim/snippets/skeleton.py<CR>o<TAB>", opts)
-- keymap("n", ",pa", ":-1read $HOME/.config/nvim/snippets/skeleton_aio.py<CR>4ja<TAB>", opts)

-- Netrw
keymap("n", "<leader>E", ":20Lexplore!<CR>", { desc = "Netrw" }) -- Open on right side

keymap("n", "gx", '<cmd>silent !xdg-open "<cfile>"<CR>', { desc = "Open" })
keymap("n", "<leader>x", '<cmd>silent !nsxiv-url "<cfile>"<CR>', { desc = "Nsxiv" })
