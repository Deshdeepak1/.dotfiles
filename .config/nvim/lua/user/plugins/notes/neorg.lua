return {
    {
        "nvim-neorg/neorg",
        cond = false,
        cmd = "Neorg",
        ft = "norg",
        dependencies = {
            "laher/neorg-exec",
            "nvim-neorg/neorg-telescope",
            "luarocks.nvim",
        },
        keys = {
            {
                "<localleader>ni",
                ":Neorg index<CR>",
                desc = "Index",
                silent = true
            },
            {
                "<localleader>nq",
                ":Neorg return<CR>",
                desc = "Return",
                silent = true
            },
            {
                "<localleader>jj",
                ":Neorg journal today<CR>",
                desc = "Journal.Today",
                silent = true
            },
            {
                "<localleader>jy",
                ":Neorg journal yesterday<CR>",
                desc = "Journal Yesterday",
                silent = true
            },
            {
                "<localleader>jt",
                ":Neorg journal tomorrow<CR>",
                desc = "Journal Tomorrow",
                silent = true
            },
            {
                "<localleader>is",
                ":Neorg generate-workspace-summary<CR>",
                desc = "Insert Summary",
                silent = true
            },
            {
                "<localleader>im",
                ":Neorg inject-metadata<CR>",
                desc = "Inject Metadata",
                silent = true
            },
            {
                "<localleader>iM",
                ":Neorg update-metadata<CR>",
                desc = "Update Metadata",
                silent = true
            },
            {
                "<localleader>x",
                ":Neorg exec cursor<CR>",
                desc = "Exec Cursor",
                silent = true
            },
            {
                "<localleader>X",
                ":Neorg exec current-file<CR>",
                desc = "Exec file",
                silent = true,
            },
            {
                "<localleader>c",
                ":Neorg exec clear<CR>",
                desc = "Exec clear",
                silent = true
            },
            {
                "<localleader>Tt",
                ":Neorg toc<CR>",
                desc = "TOC",
                silent = true
            },
            {
                "<localleader>Tc",
                ":Neorg toggle-concealer<CR>",
                desc = "Toggle Concealer",
                silent = true
            },
            { "<leader>nn", ":Neorg workspace notes<cr>", desc = "Notes Workspace", silent = false },
            { "<leader>nw", ":Neorg workspace ", desc = "Workspace", silent = false },

        },
        config = function()
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {}, -- Loads default behaviour
                    ["core.concealer"] = {  -- Adds pretty icons to your documents
                        config = {
                            folds = true,
                            icon_preset = "varied",
                            icons = {
                                code_block = {
                                    conceal = true,
                                    -- highlight = "CursorLine",
                                },
                            },
                        },
                    },
                    ["core.esupports.metagen"] = {
                        config = {
                            type = "auto",
                        }
                    },

                    ["core.summary"] = {},
                    ["core.export"] = {},
                    ["core.export.markdown"] = {
                        config = {
                            extensions = "all",
                        }
                    },
                    ["core.completion"] = {
                        config = {
                            engine = "nvim-cmp",
                            name = "[Neorg]",
                        },
                    },
                    ["core.dirman"] = { -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                notes = "~/notes",
                                -- oopd = "~/notes/mtech/oopd",
                            },
                            default_workspace = "notes",
                        },
                    },
                    ["core.highlights"] = {
                        config = {
                            highlights = {
                                tags = {
                                    ranged_verbatim = {
                                        -- code_block = "guibg=#111111",
                                        code_block = "guibg=#1c1c1c",
                                        -- code_block = "+CursorLine",
                                    },
                                },
                            },
                            -- dim = {
                            --     tags = {
                            --         ranged_verbatim = {
                            --             code_block = {
                            --                 affect = "background",
                            --                 percentage = -100,
                            --                 reference = "normal",
                            --             }
                            --         }
                            --     },
                            -- },
                        },
                    },
                    -- ["core.integrations.treesitter"] = {},
                    -- ["core.integrations.telescope"] = {
                    --
                    -- },
                    ["external.exec"] = { -- Exec code blocks
                        config = {
                            lang_cmds = {
                                cpp = {
                                    cmd = "g++ ${0} -std=c++20 && ./a.out && rm ./a.out",
                                    type = "compiled",
                                    -- main_wrap = [[
                                    -- #include <iostream>
                                    -- int main() {
                                    --     ${1}
                                    -- }
                                    -- ]],
                                    main_wrap = [[
                                        ${1}
                                    ]],
                                },
                            }
                        }
                    },
                },

            }
        end,
    },
}
