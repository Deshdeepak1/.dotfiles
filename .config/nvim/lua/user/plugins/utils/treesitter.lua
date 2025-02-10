return {
    {
        "nvim-treesitter/nvim-treesitter",
        -- cond = false,
        -- lazy = false,
        -- event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
            "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/playground",
        },
        config = function()
            local configs = require("nvim-treesitter.configs")

            local textobjects = { -- TODO: habituate using this
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

            configs.setup({
                ensure_installed = {
                    "c", "cpp", "glsl", "lua", "vim", "vimdoc",
                    "regex",
                    "csv", "yaml", "json",
                    --[[ "toml", ]]
                    -- "ssh_config", --[[ "tmux", ]]
                    "python", "kotlin",
                    "fish", "bash",
                    "html", "css", "javascript", "typescript",
                    "markdown", "markdown_inline", "norg", "org",
                    "git_config", "git_rebase", "gitcommit", "gitattributes", "gitignore"
                },
                sync_install = false,
                auto_install = false,
                highlight = {
                    enable = true,
                    -- enable = false,
                    additional_vim_regex_highlighting = {"org"},
                },
                indent = {
                    enable = true,
                    -- enable = false,
                    disable = { --[[ "cpp", ]] --[[ "lua",  ]] },
                },
                incremental_selection = {
                    enable = true,
                    -- enable = false,
                    keymaps = {
                        init_selection = "<C-Space>", -- set to `false` to disable one of the mappings
                        node_incremental = "<C-Space>",
                        -- scope_incremental = --[[  "grc" ]] false,
                        scope_incremental = "<C-M-Space>",
                        node_decremental = "<BS>",
                        -- init_selection = "<Leader>ss", -- set to `false` to disable one of the mappings
                        -- node_incremental = "<Leader>si",
                        -- scope_incremental = "<Leader>sc",
                        -- node_decremental = "<Leader>sd",
                    },
                },
                textobjects = textobjects,
                playground = playground,
            })

            require('ts_context_commentstring').setup({
                enable_autocmd = false,
            })

            vim.g.skip_ts_context_commentstring_module = true

            vim.opt.foldmethod = vim.fn.filereadable(".nvim.lua") and vim.opt.foldmethod or "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        end
    },
}
