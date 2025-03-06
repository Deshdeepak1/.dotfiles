return {
  "stevearc/conform.nvim",
  -- cond = false,
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      "<leader>F",
      function()
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "Confirm Format",
    },
    {
      -- Customize or remove this keymap to your liking
      "<leader>tf",
      function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify("AutoFormat=" .. tostring(not vim.g.disable_autoformat), vim.log.levels.INFO, { id = "autoformat" })
      end,
      mode = "n",
      desc = "AutoFormatToggle",
    },
    {
      -- Customize or remove this keymap to your liking
      "<leader>tF",
      function()
        vim.b.disable_autoformat = not vim.b.disable_autoformat
        vim.notify(
          "BufAutoFormat=" .. tostring(not vim.b.disable_autoformat),
          vim.log.levels.INFO,
          { id = "bufautoformat" }
        )
      end,
      mode = "n",
      desc = "BufAutoFormatToogle",
    },
  },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format", "ruff_organize_imports" },
      -- cpp = false,
      -- c = false,
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
    -- Set default options
    default_format_opts = {
      -- lsp_format = "fallback",
      lsp_format = "never",
    },
    -- Set up format-on-save
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    -- Customize formatters
    formatters = {
      -- shfmt = {
      --   prepend_args = { "-i", "2" },
      -- },
      stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
