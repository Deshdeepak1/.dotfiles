---@module "lazy"
---@type LazySpec

-- Fast glibc minor version detection via libuv readlink (no shell spawn, ~1-3 µs).
-- Returns nil on non-glibc systems (macOS, musl/Alpine).
local function glibc_minor()
  local paths = {
    "/lib64/libc.so.6",                  -- RHEL / Fedora / CentOS
    "/lib/x86_64-linux-gnu/libc.so.6",  -- Debian / Ubuntu x86_64
    "/lib/aarch64-linux-gnu/libc.so.6", -- Debian / Ubuntu ARM64
    "/usr/lib/libc.so.6",               -- Arch Linux
    "/lib/libc.so.6",                   -- generic fallback
  }
  for _, p in ipairs(paths) do
    local link = vim.uv.fs_readlink(p)
    if link then
      local v = tonumber(link:match("libc%-2%.(%d+)%.so"))
      if v then return v end
    end
  end
end

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
      pip = {
        upgrade_pip = true,
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
        { "stylua", version = (glibc_minor() or 99) < 30 and "v2.0.2" or nil },

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
