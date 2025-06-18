local expand = vim.fn.expand

local options = {
  number = true,
  relativenumber = true,

  -- Left column
  numberwidth = 2,
  -- signcolumn = "auto:1-3",
  signcolumn = "yes:2",
  -- foldcolumn = "auto:1",
  -- foldcolumn = "5",
  -- statuscolumn = "",

  shiftwidth = 0, -- Takes from tabstop
  tabstop = 4,
  softtabstop = -1, -- Takes from shiftwidth
  expandtab = true,
  smarttab = true,
  smartindent = true,
  preserveindent = true,
  copyindent = true,

  syntax = "on",
  mouse = "a",
  mousemoveevent = true,
  ruler = true,
  wrap = false,
  linebreak = true,
  foldenable = true,
  foldlevelstart = 99,
  foldexpr = "v:lua.vim.treesitter.foldexpr()",
  undodir = expand("~/.local/share/nvim/undo"),
  undofile = true,
  incsearch = true,
  scrolloff = 8,
  termguicolors = true,
  updatetime = 100,
  timeout = true,
  timeoutlen = 300,
  cursorline = true,
  pumheight = 10,
  conceallevel = 2,
  concealcursor = "c",
  virtualedit = "block",
  swapfile = false,
  fileencoding = "utf-8",
  completeopt = { "menuone", "noselect" },
  showmode = false,
  exrc = true,
  winborder = "rounded",

  -- Whitespaces
  listchars = "tab:<->,trail:-,nbsp:␣,space:·",
  list = true,

  -- Autocompletion :find
  wildmenu = true,
  path = ".,,**",
  wildmode = "full",

  -- Fix splitting
  splitright = true,
  splitbelow = true,

  -- BACKUPDIR:
  backup = false,
  writebackup = false,
  backupdir = expand("~/.local/share/nvim/backup"),
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.whichwrap:append("l,h,<,>,[,]")
vim.opt.shortmess:append("c")

if vim.fn.filereadable(".nvim.lua") == 0 then vim.opt.foldmethod = "expr" end

vim.cmd([[colorscheme habamax]])
