return {
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
                    "markdown_inline", "query", "norg", "norg_meta",
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
                    disable = { "cpp", --[[ "lua",  ]] },
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
}
