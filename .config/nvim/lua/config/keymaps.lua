local opts = { noremap = true }
local keymap = vim.keymap.set

keymap("", "<SPACE>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Save  Quit
keymap("n", "<leader>q", ":bdelete<CR>", { desc = "CloseBuffer" })
keymap("n", "<leader>Q", ":quitall!<CR>", { desc = "QuitAll" })
keymap("n", "<leader>S", ":luafile %<CR>", { desc = "Source" })

-- Toggles

-- number toggle
keymap("n", "<leader>tl", function()
  vim.o.number = not vim.o.number
  vim.notify("Number="..tostring(vim.o.number))
end, { desc = "NumberToggle" })

-- relative number toggle
keymap("n", "<leader>tL", function()
  vim.o.relativenumber = not vim.o.relativenumber
  vim.notify("RelativeNumber="..tostring(vim.o.relativenumber))
end, { desc = "RelativeNumberToggle" })

-- wrap toggle
keymap("n", "<leader>tw", function()
  vim.o.wrap = not vim.o.wrap
  vim.notify("Wrap="..tostring(vim.o.wrap))
end, { desc = "WrapToggle" })

-- spell toggle
keymap("n", "<leader>ts", function()
  vim.o.spell = not vim.o.spell
  vim.notify("Spell="..tostring(vim.o.spell))
end, { desc = "SpellToggle" })
-- TODO: learn spell
-- z= , :spellr, zg

-- conceallevel toggle
keymap("n", "<leader>tc", function()
  if vim.o.conceallevel == 0 then
    vim.o.conceallevel = 2
  else
    vim.o.conceallevel = 0
  end
  vim.notify("Concellevel="..tostring(vim.o.conceallevel))
end, { desc = "ConvealLevelToggle" })

-- TODO: learn :norm, gv,marks

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
keymap("n", "<leader>bb", ":e #<CR>", { desc = "LastOpenedBuffer" })
keymap("n", "<TAB>", ":bnext<CR>", opts)
keymap("n", "]b", ":bnext<CR>", opts)
keymap("n", "<S-TAB>", ":bprevious<CR>", opts)
keymap("n", "[b", ":bprevious<CR>", opts)

-- Sed like subsitutions
keymap("n", "<M-s>", ":%s///gI<Left><Left><Left><Left>", opts)
keymap("v", "<M-s>", ":s///gI<Left><Left><Left><Left>", opts)
keymap("n", "<C-s>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "RepCurWord" })
keymap("v", "<C-s>", [[:s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "RepCurWord" })

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
keymap("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "Prev" })
keymap("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = "Next" })


-- TODO: Learn CTags
-- ctags: !ctags -R .
-- C-]  jump to tag, C-t Jump back , gC-] ambiguous tags


-- TODO: Learn Autocompletion
-- Learn C-n Completion next, C-p prev,  C-xC-f compelte filename, C-xC-] ctags completion

-- TODO: Learn JUMPS
-- , and  ; for f, F, t, T

-- My Snippets -- Port to vim and fix cp
keymap("n", "<localleader>h", ":-1read $HOME/.config/nvim/snippets/skeleton.html<CR>3jwf>a", opts)
keymap("n", "<localleader>c", ":-1read $HOME/.config/nvim/snippets/skeleton.c<CR>3ja<TAB>", opts)
keymap("n", "<localleader>cc", ":-1read $HOME/.config/nvim/snippets/skeleton.cpp<CR>4ja<TAB>", opts)
keymap("n", "<localleader>cp", ":-1read $HOME/.config/nvim/snippets/skeleton_cp.cpp<CR>5ja<TAB>", opts)
keymap("n", "<localleader>p", ":-1read $HOME/.config/nvim/snippets/skeleton.py<CR>o<TAB>", opts)
keymap("n", "<localleader>pa", ":-1read $HOME/.config/nvim/snippets/skeleton_aio.py<CR>4ja<TAB>", opts)

-- Netrw
keymap("n", "<leader>E", ":20Lexplore!<CR>", { desc = "Netrw" }) -- Open on right side

keymap("n", "gx", '<cmd>silent !xdg-open "<cfile>"<CR>', { desc = "Open" })
keymap("n", "<leader>x", '<cmd>silent !nsxiv-url "<cfile>"<CR>', { desc = "Nsxiv" })

-- Comment nvim >= 0.10
keymap("n", "<leader>/", "gcc", { desc = "Comment", remap = true })
keymap("v", "<leader>/", "gc", { desc = "Comment", remap = true })
