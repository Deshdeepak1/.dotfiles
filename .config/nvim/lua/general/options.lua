
-- Assignments
-- o = vim.opt
-- o.number = true
-- o.relativenumber = true
local exp = vim.fn.expand

-- options table ( Similar to dicts)
local options = {
    number = true,
    relativenumber = true,
    numberwidth = 2,

    tabstop = 4,
    shiftwidth = 4,
    softtabstop = 4,
    expandtab = true,
    smarttab = true,

    mouse = "a",
    smartindent = true,
    -- cindent = true,
    ruler = true,
    -- nohlsearch = true,
    -- hlsearch = true,
    hlsearch = false,
    -- hidden = true,
    -- noerrorbells = true,
    -- nowrap = true,
    -- wrap = true,
    wrap = false,
    undodir = exp("~/.local/share/nvim/undo"),
    undofile = true,
    incsearch = true,
    scrolloff = 8,
    termguicolors = true,
    updatetime = 100,
    timeoutlen = 300,
    cursorline = true,
    signcolumn = "yes",
    shell = "sh",
    pumheight = 10,
    conceallevel = 0,
    swapfile = false,
    fileencoding = "utf-8",
    completeopt = { "menuone", "noselect" } ,

    -- Whitespaces
    listchars = "tab:<->,trail:-,nbsp:␣,space:·,precedes:«",
    -- ,eol:↲,extends:»
    list = true,

    -- Don't pass messages to |ins-completion-menu|.

    -- Autocompletion
    -- wildmode = "longest,list",
    -- wildmode = "longest:list,full",
    wildmode = "longest,list,full",
    -- wildoptions = "",

    -- Fix splitting
    splitright = true,
    splitbelow = true,


    -- CHAR LIMIT:
    --highlight ColorColumn ctermbg=gray
    --filetype detect
    --if &filetype=='python'
        --set cc=79
    --endif
    --autocmd BufNewFile,BufRead *.py set cc=79

    -- Remove trailing whitespace
    --autocmd BufWritePre * %s/\s\+$//e

    -- BACKUPDIR:
    backupdir = exp("~/.local/share/nvim/backup"),

}
-- for loop, pairs
for k, v in pairs(options) do
    vim.opt[k] = v
end

-- Append string
vim.opt.shortmess:append "c"
-- vim.opt.iskeyword:append "-"

-- vim command
vim.cmd "set whichwrap+=<,>,[,],h,l"

-- Colorschemes
-- gruvbox
-- monokai_pro , monokai
-- molokai
-- onehalfdark
-- codemonkey
-- darkplus
-- onedarker

-- vim.cmd "hi HighlightedyankRegion cterm=bold gui=bold ctermbg=DarkGrey guibg=DarkGrey"
vim.cmd "au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }"
