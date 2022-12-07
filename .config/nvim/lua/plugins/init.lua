local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

local st_ok, packer = pcall(require, "packer")
if not st_ok then
    return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

packer.startup(function(use)
    use("wbthomason/packer.nvim")
    use("lewis6991/impatient.nvim")

    -- Colorschemes
    -- use "folke/tokyonight.nvim"
    -- use "lunarvim/onedarker.nvim"
    -- use "lunarvim/darkplus.nvim"
    -- use "lunarvim/colorschemes"
    use("tanvirtin/monokai.nvim")
    -- use("novakne/kosmikoa.nvim")
    -- use("ful1e5/onedark.nvim")
    -- use("olimorris/onedarkpro.nvim")
    -- use("sainnhe/everforest")
    -- use("sainnhe/edge")
    -- use("ofirgall/ofirkai.nvim")
    -- use("sainnhe/sonokai")
    -- use("bluz71/vim-nightfly-colors")
    -- use("bluz71/vim-moonfly-colors")
    -- use("Mofiqul/vscode.nvim")
    -- use("marko-cerovac/material.nvim")
    -- use("rafamadriz/neon")
    -- use("mhartington/oceanic-next")
    -- use {"sonph/onehalf", rtp = "vim"}
    -- use "Mofiqul/dracula.nvim"
    -- use "ellisonleao/gruvbox.nvim"
    -- use  "gruvbox-community/gruvbox"
    -- use {"tomasr/molokai", rtp = "colors"}
    -- use { "navarasu/onedark.nvim" }
    -- use "sam4llis/nvim-tundra"

    use("kyazdani42/nvim-web-devicons")
    use("windwp/nvim-autopairs")
    use("numToStr/Comment.nvim")
    use("NvChad/nvim-colorizer.lua")
    use("tpope/vim-surround")
    use("tpope/vim-repeat")
    use("lukas-reineke/indent-blankline.nvim")
    use("noib3/nvim-cokeline")
    use("lewis6991/gitsigns.nvim")
    use("feline-nvim/feline.nvim")

    use("tpope/vim-fugitive")

    use("folke/which-key.nvim")
    use("nvim-tree/nvim-tree.lua")

    use("nvim-lua/plenary.nvim")
    use({ "nvim-telescope/telescope.nvim", tag = '0.1.0', })
    use({'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })


    use("neovim/nvim-lspconfig")
    use("williamboman/mason.nvim")
    use("hrsh7th/nvim-cmp")
    use("onsails/lspkind.nvim")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lsp-signature-help")
    use("saadparwaiz1/cmp_luasnip")
    use("hrsh7th/cmp-nvim-lua")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-cmdline")
    use("mtoohey31/cmp-fish")

    use("L3MON4D3/LuaSnip")
    use "rafamadriz/friendly-snippets"

    use("nvim-treesitter/nvim-treesitter")
    use("JoosepAlviste/nvim-ts-context-commentstring")
    use("p00f/nvim-ts-rainbow")






    if packer_bootstrap then
        packer.sync()
    end
end)
local colorscheme = "monokai"
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
    vim.notify(colorscheme .. " not found")
    vim.cmd "colorscheme default"
end

local npairs_st, npairs = pcall(require, "nvim-autopairs")
if npairs_st then
    npairs.setup({
        check_ts = true,
        fast_wrap = {},
    })
end
local ok, colorizer = pcall(require, "colorizer")
if ok then
    colorizer.setup()
end
local comment_ok, comment = pcall(require, "Comment")
if comment_ok then
    comment.setup()
end
local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
if gitsigns_ok then
    gitsigns.setup()
end
local impatient_ok, impatient = pcall(require, "impatient")
if impatient_ok then
    impatient.enable_profile()
end
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
    mason.setup()
end
require("plugins.indentline")
require("plugins.cokeline")
require("plugins.feline")
require("plugins.which-key")
require("plugins.nvim-tree")
require("plugins.telescope")
require("plugins.treesitter")
