return {
    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        tag = "0.1.2",
        -- event = "VeryLazy",
        -- cond = false,
        cond = not vim.g.started_by_firenvim,
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
        cond = not vim.g.started_by_firenvim,
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
        cond = not vim.g.started_by_firenvim,
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
        end,
        config = function()
            vim.api.nvim_create_autocmd({ 'BufEnter' }, {
                pattern = { "github.com_*.txt", },
                command = "set filetype=markdown"
            })
            vim.api.nvim_create_autocmd({ 'BufEnter' }, {
                pattern = { "leetcode.com_*.txt", "www.learning.algozenith.com_*.c" },
                command = "set filetype=cpp"
            })
        end
    },
    {
        'xeluxee/competitest.nvim',
        cmd = "CompetiTest",
        dependencies = 'MunifTanjim/nui.nvim',
        config = function()
            require('competitest').setup {
                local_config_file_name = ".competitest.lua",

                floating_border = "rounded",
                floating_border_highlight = "FloatBorder",
                picker_ui = {
                    width = 0.2,
                    height = 0.3,
                    mappings = {
                        focus_next = { "j", "<down>", "<Tab>" },
                        focus_prev = { "k", "<up>", "<S-Tab>" },
                        close = { "<esc>", "<C-c>", "q", "Q" },
                        submit = { "<cr>" },
                    },
                },
                editor_ui = {
                    popup_width = 0.4,
                    popup_height = 0.6,
                    show_nu = true,
                    show_rnu = false,
                    normal_mode_mappings = {
                        switch_window = { "<C-h>", "<C-l>", "<C-i>" },
                        save_and_close = "<C-s>",
                        cancel = { "q", "Q" },
                    },
                    insert_mode_mappings = {
                        switch_window = { "<C-h>", "<C-l>", "<C-i>" },
                        save_and_close = "<C-s>",
                        cancel = "<C-q>",
                    },
                },
                runner_ui = {
                    interface = "split",
                    selector_show_nu = false,
                    selector_show_rnu = false,
                    show_nu = true,
                    show_rnu = false,
                    mappings = {
                        run_again = "R",
                        run_all_again = "<C-r>",
                        kill = "K",
                        kill_all = "<C-k>",
                        view_input = { "i", "I" },
                        view_output = { "a", "A" },
                        view_stdout = { "o", "O" },
                        view_stderr = { "e", "E" },
                        toggle_diff = { "d", "D" },
                        close = { "q", "Q" },
                    },
                    viewer = {
                        width = 0.5,
                        height = 0.5,
                        show_nu = true,
                        show_rnu = false,
                        close_mappings = { "q", "Q" },
                    },
                },
                popup_ui = {
                    total_width = 0.8,
                    total_height = 0.8,
                    layout = {
                        { 4, "tc" },
                        { 5, { { 1, "so" }, { 1, "si" } } },
                        { 5, { { 1, "eo" }, { 1, "se" } } },
                    },
                },
                split_ui = {
                    position = "right",
                    relative_to_editor = true,
                    total_width = 0.4,
                    vertical_layout = {
                        { 2, { { 1, "si" }, { 1, "so" }, { 1, "eo" } } },
                        { 1, { { 1, "tc" }, { 1, "se" } } },
                    },
                    total_height = 0.4,
                    horizontal_layout = {
                        { 2, "tc" },
                        { 3, { { 1, "so" }, { 1, "si" } } },
                        { 3, { { 1, "eo" }, { 1, "se" } } },
                    },
                },

                save_current_file = true,
                save_all_files = false,
                compile_directory = ".",
                compile_command = {
                    c = { exec = "gcc", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
                    cpp = { exec = "g++", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
                    rust = { exec = "rustc", args = { "$(FNAME)" } },
                    java = { exec = "javac", args = { "$(FNAME)" } },
                },
                running_directory = ".",
                run_command = {
                    c = { exec = "./$(FNOEXT)" },
                    cpp = { exec = "./$(FNOEXT)" },
                    rust = { exec = "./$(FNOEXT)" },
                    python = { exec = "python", args = { "$(FNAME)" } },
                    java = { exec = "java", args = { "$(FNOEXT)" } },
                },
                multiple_testing = -1,
                maximum_time = 5000,
                output_compare_method = "squish",
                view_output_diff = false,

                testcases_directory = ".",
                testcases_use_single_file = false,
                testcases_auto_detect_storage = true,
                testcases_single_file_format = "$(FNOEXT).testcases",
                testcases_input_file_format = "$(FNOEXT)_input$(TCNUM).txt",
                testcases_output_file_format = "$(FNOEXT)_output$(TCNUM).txt",

                companion_port = 27121,
                receive_print_message = true,
                template_file = {
                    cpp = "~/.config/nvim/snippets/skeleton_cp.cpp",
                },
                evaluate_template_modifiers = false,
                date_format = "%c",
                received_files_extension = "cpp",
                received_problems_path = "$(CWD)/$(JUDGE)/$(PROBLEM)/$(PROBLEM).$(FEXT)",
                received_problems_prompt_path = false,
                received_contests_directory = "$(CWD)",
                received_contests_problems_path = "$(PROBLEM).$(FEXT)",
                received_contests_prompt_directory = true,
                received_contests_prompt_extension = true,
                open_received_problems = true,
                open_received_contests = true,
            }
        end,
        -- config = true,
    },

}
