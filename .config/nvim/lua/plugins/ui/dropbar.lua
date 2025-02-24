return {
  'Bekaboo/dropbar.nvim',
  event = { "BufReadPost", "BufNewFile" },
  -- cond = false,
  -- lazy = false,
  -- event = "VeryLazy",
  -- optional, but required for fuzzy finder support
  -- dependencies = {
  --   'nvim-telescope/telescope-fzf-native.nvim',
  --   build = 'make'
  -- },
  config = function()
    local dropbar_api = require('dropbar.api')
    vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
    vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
    vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })

    function toggle_dropbar()
      if vim.o.winbar == "" then
        vim.o.winbar = "%{%v:lua.dropbar()%}"
      else
        vim.o.winbar = ""
      end
    end

    vim.keymap.set("n", "<Leader>B", toggle_dropbar, { desc = "Toggle [B]readcrumbs", })

    require("dropbar").setup({
      sources = {
        treesitter = {
          valid_types = {
            'array',
            'boolean',
            'break_statement',
            -- 'call',
            'case_statement',
            'class',
            'constant',
            'constructor',
            'continue_statement',
            'delete',
            'do_statement',
            'element',
            'enum',
            'enum_member',
            'event',
            'for_statement',
            'function',
            'h1_marker',
            'h2_marker',
            'h3_marker',
            'h4_marker',
            'h5_marker',
            'h6_marker',
            -- 'if_statement',
            'interface',
            'keyword',
            'macro',
            'method',
            -- 'module',
            'namespace',
            'null',
            'number',
            'operator',
            'package',
            'pair',
            'property',
            'reference',
            'repeat',
            'rule_set',
            'scope',
            'specifier',
            'struct',
            'switch_statement',
            'type',
            'type_parameter',
            'unit',
            'value',
            'variable',
            'while_statement',
            'declaration',
            'field',
            'identifier',
            'object',
            'statement',
          },
        },
        -- lsp = {valid_symbols = {}},
        path = {max_depth = 0},

      }
    })

  end
}
