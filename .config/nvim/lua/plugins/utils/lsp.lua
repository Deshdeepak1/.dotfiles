---@module "lazy"
---@type LazySpec
return {
  {
    "mason-org/mason.nvim",
    -- event = "VeryLazy",
    lazy = false,
    -- cond = false,
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog", "MasonUpdate" },
    keys = {
      { "<leader>mo", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts = {
      ui = {
        check_outdated_packages_on_open = true,
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- event = "VeryLazy",
    -- cond = false,
    cmd = {
      "MasonToolsInstall",
      "MasonToolsInstallSync",
      "MasonToolsUpdate",
      "MasonToolsUpdateSync",
      "MasonToolsClean",
    },
    keys = {
      { "<leader>mi", "<cmd>MasonToolsInstall<cr>", desc = "MasonToolsInstall" },
    },
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = {
        -- Lsp
        "lua-language-server",
        -- "lua_ls",
        "basedpyright",
        "ruff",
        "clangd",
        "json-lsp",
        "typescript-language-server",

        -- formatter
        { "stylua", version = "v2.0.2" },

        -- DAP
        "codelldb",
        "debugpy",
      },
      integrations = {
        ["mason-lspconfig"] = false,
        ["mason-null-ls"] = false,
        ["mason-nvim-dap"] = false,
      },
      run_on_start = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    -- lazy = false,
    -- cond = false,
    ft = { "python", "lua", "cpp", "html", "css", "javascript", "typescript", "kotlin", "glsl", "markdown" },
    cmd = { "LspInfo", "LspStart", "LspInstall", "LspRestart" },
    dependencies = {
      "mason-org/mason.nvim",
      -- "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function() end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "b0o/SchemaStore.nvim",
  },
}
