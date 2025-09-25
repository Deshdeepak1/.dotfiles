---@module "lazy"
---@type LazySpec
return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    version = "1.11.0",
    priority = 1000,
    -- cond = false,
    ---@module "catppuccin"
    ---@type CatppuccinOptions
    opts = {
      transparent_background = true,
      custom_highlights = function(colors)
        return {
          LineNr = { fg = colors.overlay0 },
          TabLineSel = { bg = colors.blue },
          GitSignsChange = { fg = colors.sky },
          -- IlluminatedWordText = {bg = "#333333"},
          -- IlluminatedWordRead = {bg = "#333333"},
          -- IlluminatedWordWrite = {bg = "#333333"},
          -- DiagnosticUnderlineError = { gui = "undercurl" },
        }
      end,
      integrations = {
        flash = false,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
            ok = { "undercurl" },
          },
        },
      },
      -- float = {
      --   transparent = true,
      --   solid = false,
      -- },
    },
    init = function()
      -- https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/palettes/mocha.lua
      vim.cmd([[colorscheme catppuccin-mocha]])
    end,
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
    -- cond = false,
    lazy = false,
    priority = 1000,
    opts = {},
    init = function()
      -- vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
}
