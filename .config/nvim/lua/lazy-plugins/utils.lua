return {
    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        tag = "0.1.2",
        -- event = "VeryLazy",
        -- cond = false,
        cmd = "Telescope",
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local builtins = require("telescope.builtin")

            local picker_config = {}
            for b, _ in pairs(builtins) do
                picker_config[b] = { layout_config = { preview_width = 0.55 } }
            end
            telescope.setup({
                defaults = {

                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = { "smart" },
                },
                pickers = picker_config,
            })
            telescope.load_extension('fzf')
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        -- cond = false,
        -- lazy = false,
        build = ":TSUpdate",
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
            "nvim-treesitter/nvim-treesitter-textobjects",
            "windwp/nvim-ts-autotag",
            "nvim-treesitter/playground",
        },
        config = function()
            local configs = require("nvim-treesitter.configs")

            local textobjects = {
                select = {
                    enable = true,
                    -- enable = false,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
                move = {
                    enable = true,
                    -- enable = false,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]]"] = "@class.outer",
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]["] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[["] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[M"] = "@function.outer",
                        ["[]"] = "@class.outer",
                    },
                },
            }

            local playground = {
                enable = true,
                -- enable = false,
                disable = {},
                updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = false, -- Whether the query persists across vim sessions
                keybindings = {
                    toggle_query_editor = 'o',
                    toggle_hl_groups = 'i',
                    toggle_injected_languages = 't',
                    toggle_anonymous_nodes = 'a',
                    toggle_language_display = 'I',
                    focus_language = 'f',
                    unfocus_language = 'F',
                    update = 'R',
                    goto_node = '<cr>',
                    show_help = '?',
                },
            }

            local autotag = {
                enable = true,
                -- enable = false,
            }
            configs.setup({
                ensure_installed = {
                    "c", "python", "lua", "cpp", "html", "fish", "bash", "css", "typescript", "javascript", "markdown",
                    "markdown_inline", "query",
                },
                sync_install = false,
                auto_install = false,
                highlight = {
                    enable = true,
                    -- enable = false,
                    -- additional_vim_regex_highlighting = true,
                },
                indent = {
                    enable = true,
                    -- enable = false,
                    -- disable = { "python", --[[ "lua"  ]] },
                },
                context_commentstring = {
                    enable = true,
                    -- enable = false,
                    enable_autocmd = false,
                },
                incremental_selection = {
                    enable = true,
                    -- enable = false,
                    keymaps = {
                        init_selection = "<C-Space>", -- set to `false` to disable one of the mappings
                        node_incremental = "<C-Space>",
                        scope_incremental = --[[  "grc" ]] false,
                        node_decremental = "<bs>",
                    },
                },
                textobjects = textobjects,
                autotag = autotag,
                playground = playground,
            })
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        end
    },

    -- TMUX
    {
        "alexghergh/nvim-tmux-navigation",
        event = "VeryLazy",
        cond = function()
            -- return false
            return os.getenv("TMUX") ~= nil
        end,
        config = function()
            require('nvim-tmux-navigation').setup({
                -- disable_when_zoomed = true, -- defaults to false
                keybindings = {
                    left = "<C-h>",
                    down = "<C-j>",
                    up = "<C-k>",
                    right = "<C-l>",
                    last_active = "<C-\\>",
                    next = "<C-Space>",
                }
            })
        end
    },

    -- Oil
    {
        'stevearc/oil.nvim',
        lazy = false,
        -- event = "VeryLazy",
        -- cond = false,
        -- opts = {},
        config = function()
            local oil = require("oil")
            oil.setup({
                columns = {
                    "icon",
                    -- "permissions",
                },
                skip_confirm_for_simple_edits = true,
                keymaps = {
                    ["<leader>t"] = "actions.open_terminal",
                    ["<leader>T"] = {
                        desc = "Toggle detail view",
                        callback = function()
                            local oil = require("oil")
                            local config = require("oil.config")
                            if #config.columns == 1 then
                                oil.set_columns({ "icon", "permissions", "size", "mtime" })
                            else
                                oil.set_columns({ "icon" })
                            end
                        end,
                    },
                },
                float = {
                    max_height = 40,
                    max_width = 100,
                    win_options = { winblend = 0 },
                    -- override = function(conf)
                    --     return conf
                    -- end,
                },
            })
            vim.keymap.set("n", "<leader>e", oil.toggle_float, { noremap = true, desc = "Oil Toggle" })
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        -- event = "VeryLazy",
        -- cmd = { "MarkdownPreviewToggle" },
        ft = { "markdown", "quarto" },
        -- cond = false,
        -- init = function()
        --     vim.fn["mkdp#util#install"]()
        --     vim.g.mkdp_filetypes = { "markdown", "quarto" }
        -- end,
        config = function()
            vim.fn["mkdp#util#install"]()
            vim.g.mkdp_filetypes = { "markdown", "quarto" }
        end,
    },
    {
        "mbbill/undotree",
        event = "VeryLazy",
        -- cond = false,
    },
    {
        'glacambre/firenvim',
        -- cond = false,

        -- Lazy load firenvim
        -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
        lazy = not vim.g.started_by_firenvim,
        build = function()
            vim.fn["firenvim#install"](0)
        end
    },

}
