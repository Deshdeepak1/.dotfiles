---@module "lazy"
---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    -- cond = false,
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        opts = {
          -- TODO: habituate using this
          select = {
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            include_surrounding_whitespace = true,
          },
          move = {
            set_jumps = true, -- whether to set jumps in the jumplist
          },
        },
        config = function(_, opts)
          require("nvim-treesitter-textobjects").setup(opts)

          -- Objects
          vim.keymap.set(
            { "x", "o" },
            "aa",
            function()
              require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
            end
          )
          vim.keymap.set(
            { "x", "o" },
            "ia",
            function()
              require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
            end
          )
          vim.keymap.set(
            { "x", "o" },
            "ac",
            function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects") end
          )
          vim.keymap.set(
            { "x", "o" },
            "ic",
            function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects") end
          )

          -- swaps
          vim.keymap.set(
            "n",
            "<localleader>a",
            function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end
          )
          vim.keymap.set(
            "n",
            "<localleader>A",
            function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner") end
          )

          -- Move
          vim.keymap.set(
            { "n", "x", "o" },
            "]a",
            function() require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.outer", "textobjects") end
          )
          vim.keymap.set(
            { "n", "x", "o" },
            "]m",
            function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects") end
          )
          vim.keymap.set(
            { "n", "x", "o" },
            "]]",
            function() require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects") end
          )

          vim.keymap.set(
            { "n", "x", "o" },
            "]A",
            function() require("nvim-treesitter-textobjects.move").goto_next_end("@parameter.outer", "textobjects") end
          )
          vim.keymap.set(
            { "n", "x", "o" },
            "]M",
            function() require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects") end
          )
          vim.keymap.set(
            { "n", "x", "o" },
            "][",
            function() require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects") end
          )

          vim.keymap.set(
            { "n", "x", "o" },
            "[a",
            function()
              require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.outer", "textobjects")
            end
          )
          vim.keymap.set(
            { "n", "x", "o" },
            "[m",
            function() require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects") end
          )
          vim.keymap.set(
            { "n", "x", "o" },
            "[[",
            function() require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects") end
          )

          vim.keymap.set(
            { "n", "x", "o" },
            "[A",
            function() require("nvim-treesitter-textobjects.move").goto_previous_end("@parameter.outer", "textobjects") end
          )
          vim.keymap.set(
            { "n", "x", "o" },
            "[M",
            function() require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects") end
          )
          vim.keymap.set(
            { "n", "x", "o" },
            "[]",
            function() require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects") end
          )

          vim.keymap.set(
            { "n", "x", "o" },
            "]z",
            function() require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds") end
          )
          vim.keymap.set(
            { "n", "x", "o" },
            "[z",
            function() require("nvim-treesitter-textobjects.move").goto_previous_start("@fold", "folds") end
          )
        end,
      },
      -- {
      --   'daliusd/incr.nvim',
      --   opts = {
      --     incr_key = '<C-Space>', -- increment selection key
      --     decr_key = '<BS>', -- decrement selection key
      --   },
      -- },
    },
    config = function()
      local nvim_ts = require("nvim-treesitter")

      local ensure_installed = {
        "query",
        "c",
        "cpp",
        "glsl",
        "lua",
        "vim",
        "vimdoc",
        "csv",
        "yaml",
        "json",
        --[[ "toml", ]]
        -- "ssh_config", --[[ "tmux", ]]
        "python",
        "kotlin",
        "fish",
        "bash",
        "html",
        "css",
        "javascript",
        "typescript",
        "markdown",
        "markdown_inline",
        -- "norg", --[[ "org", ]]
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitattributes",
        "gitignore",
      }
      if vim.fn.executable("tree-sitter") == 1 then nvim_ts.install(ensure_installed) end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter.setup", {}),
        callback = function(args)
          local buf = args.buf
          local filetype = args.match

          local language = vim.treesitter.language.get_lang(filetype) or filetype
          if not vim.treesitter.language.add(language) then return end

          -- vim.wo.foldmethod = 'expr'
          -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

          vim.treesitter.start(buf, language)

          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
      -- local configs = require("nvim-treesitter.configs")
    end,
  },
  {
    -- "RRethy/nvim-treesitter-endwise",
    "brianhuster/treesitter-endwise.nvim",
    -- cond = false,
    -- event = {"BufReadPost", "BufNewFile"},
    ft = { "lua", "vim", "ruby", "bash", "fish" },
    -- event = "InsertEnter",
    -- lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
