local expand = vim.fn.expand
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
    mousemoveevent = true,
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
    foldenable = false,
    undodir = expand("~/.local/share/nvim/undo"),
    undofile = true,
    incsearch = true,
    scrolloff = 8,
    termguicolors = true,
    updatetime = 100,
    timeout = true,
    timeoutlen = 300,
    cursorline = true,
    signcolumn = "yes:1",
    -- signcolumn = "auto:3",
    -- signcolumn = "auto:3-4",
    -- signcolumn = "yes:2",
    -- shell = "sh",
    pumheight = 10,
    conceallevel = 1,
    swapfile = false,
    fileencoding = "utf-8",
    completeopt = { "menuone", "noselect" },

    -- Whitespaces
    -- listchars = "tab:<->,trail:-,nbsp:␣,space:·,precedes:«",
    listchars = "tab:<->,trail:-,nbsp:␣,space:·",
    -- ,eol:↲,extends:»
    list = true,


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
    backup = false,
    backupdir = expand("~/.local/share/nvim/backup"),
}
for k, v in pairs(options) do
    vim.opt[k] = v
end
-- vim.opt.formatoptions:remove("o")
vim.opt.formatoptions:remove("cro")
vim.opt.whichwrap:append "l,h,<,>,[,]"
vim.opt.shortmess:append "c"
--vim.opt.clipboard:append "unnamedplus"
vim.highlight.on_yank { higroup = 'IncSearch', timeout = 200, on_macro = true }
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200, on_macro = true })
    end
})
-- Example for configuring Neovim to load user-installed installed Lua rocks:
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
