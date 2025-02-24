return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = "VeryLazy",
  opts = {
    options = {
      icons_enabled = true,
      theme = 'catppuccin',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      always_show_tabline = false,
      globalstatus = true,
      refresh = {
        statusline = 100,
        tabline = 100,
        winbar = 100,
      }
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff'},
      lualine_c = { { '%=', separator = '' }, {'filename', path = 1 } },
      -- lualine_x = {'diagnostics', 'filetype', 'filesize'},
      lualine_x = {'diagnostics', 'filetype'},
      -- lualine_y = {'progress'},
      lualine_y = {},
      lualine_z = {'location'}
    },
    inactive_sections = {
      -- lualine_a = {},
      lualine_a = {'mode'},
      lualine_b = {},
      lualine_c = { { '%=', separator = '' }, {'filename', path = 1 } },
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
      -- lualine_a = {'mode'},
      -- lualine_b = {'branch', 'diff'},
      -- lualine_x = {'diagnostics', 'filetype', 'filesize'},
      -- lualine_y = {'progress'},
      -- lualine_z = {'location'}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
  }
}
