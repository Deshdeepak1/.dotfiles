return {
    "freddiehaddad/feline.nvim",
    event = "VeryLazy",
    -- cond = false,
    config = function()
        feline = require("feline")
        local one_monokai = {
            fg = "#abb2bf",
            bg = "#1e2024",
            green = "#98c379",
            yellow = "#e5c07b",
            purple = "#c678dd",
            orange = "#d19a66",
            peanut = "#f6d5a4",
            red = "#e06c75",
            aqua = "#61afef",
            darkblue = "#282c34",
            dark_red = "#f75f5f",
        }

        local vi_mode_colors = {
            NORMAL = "green",
            OP = "green",
            INSERT = "yellow",
            VISUAL = "purple",
            LINES = "orange",
            BLOCK = "dark_red",
            REPLACE = "red",
            COMMAND = "aqua",
        }

        local function vimode_hl()
            return {
                name = require("feline.providers.vi_mode").get_mode_highlight_name(),
                fg = require("feline.providers.vi_mode").get_mode_color()
            }
        end

        local c = {
            vim_mode = {
                provider = {
                    name = "vi_mode",
                    opts = {
                        show_mode_name = true,
                        -- padding = "center", -- Uncomment for extra padding.
                    },
                },
                hl = function()
                    return {
                        fg = require("feline.providers.vi_mode").get_mode_color(),
                        bg = "darkblue",
                        style = "bold",
                        -- name = "NeovimModeHLColor",
                        name = require('feline.providers.vi_mode').get_mode_highlight_name(),
                    }
                end,
                left_sep = "block",
                right_sep = "block",
            },
            gitBranch = {
                provider = "git_branch",
                hl = {
                    fg = "peanut",
                    bg = "darkblue",
                    style = "bold",
                },
                left_sep = "block",
                right_sep = "block",
            },
            gitDiffAdded = {
                provider = "git_diff_added",
                hl = {
                    fg = "green",
                    bg = "darkblue",
                },
                left_sep = "block",
                right_sep = "block",
            },
            gitDiffRemoved = {
                provider = "git_diff_removed",
                hl = {
                    fg = "red",
                    bg = "darkblue",
                },
                left_sep = "block",
                right_sep = "block",
            },
            gitDiffChanged = {
                provider = "git_diff_changed",
                hl = {
                    fg = "fg",
                    bg = "darkblue",
                },
                left_sep = "block",
                right_sep = "right_filled",
            },
            separator = {
                provider = "",
            },
            fileinfo = {
                provider = function(component, opts)
                    if vim.bo.filetype == "oil" then
                        -- current_dir =  require("oil").get_current_dir()
                        current_dir = vim.api.nvim_buf_get_name(0)
                        if current_dir:match("oil://") then
                            is_local = true
                        end

                        dir = vim.fn.fnamemodify(current_dir, ":s?oil://\\|oil-ssh://??")

                        if is_local then
                            dir = vim.fn.fnamemodify(dir, ":~")
                        end
                        -- dir = vim.fn.pathshorten(current_dir)
                        -- dir = vim.fn.fnamemodify(current_dir, ":t")
                        -- dir = vim.fn.fnamemodify(current_dir, ":~:.")
                        -- dir = vim.fn.fnamemodify(current_dir, ":~:")
                        -- dir = vim.fn.pathshorten(vim.fn.fnamemodify(current_dir, ':~:.'))
                        -- dir = vim.fn.pathshorten(vim.fn.fnamemodify(current_dir, ':~:'))
                        icon = { str = " ", hl = { fg = "#8caaee" } }

                        if vim.bo.modified then
                            modified_str = '●'

                            if modified_str ~= '' then
                                modified_str = ' ' .. modified_str
                            end
                        else
                            modified_str = ''
                        end

                        if vim.bo.readonly then
                            readonly_str = '🔒'
                        else
                            readonly_str = ''
                        end

                        return string.format('%s%s%s', readonly_str, dir, modified_str), icon
                    end
                    return require("feline.providers.file").file_info(component, { type = "relative-short" })
                    -- return {
                    --     name = "file_info",
                    --     opts = {
                    --         type = "relative-short",
                    --     },
                    -- }
                end,
                hl = {
                    style = "bold",
                },
                left_sep = " ",
                right_sep = " ",
            },
            diagnostic_errors = {
                provider = "diagnostic_errors",
                hl = {
                    fg = "red",
                },
            },
            diagnostic_warnings = {
                provider = "diagnostic_warnings",
                hl = {
                    fg = "yellow",
                },
            },
            diagnostic_hints = {
                provider = "diagnostic_hints",
                hl = {
                    fg = "aqua",
                },
            },
            diagnostic_info = {
                provider = "diagnostic_info",
            },
            lsp_client_names = {
                provider = "lsp_client_names",
                hl = {
                    fg = "purple",
                    bg = "darkblue",
                    style = "bold",
                },
                left_sep = "left_filled",
                right_sep = "block",
            },
            file_size = {
                provider = "file_size",
                hl = {
                    fg = "aqua",
                    bg = "darkblue",
                    style = "bold",
                },
                left_sep = "block",
                right_sep = "block",
            },
            file_type = {
                provider = function(component, opts)
                    file_type, icon = require("feline.providers.file").file_type(component,
                        { filetype_icon = true, case = "titlecase" })
                    if vim.bo.filetype == "oil" then
                        icon = { str = "", hl = { fg = "#8caaee" } }
                    end
                    return file_type, icon
                    -- {
                    --     name = "file_type",
                    --     opts = {
                    --         filetype_icon = true,
                    --         case = "titlecase",
                    --     },
                    -- }
                end,
                hl = {
                    fg = "red",
                    bg = "darkblue",
                    style = "bold",
                },
                left_sep = "block",
                right_sep = "block",
            },
            file_encoding = {
                provider = "file_encoding",
                hl = {
                    fg = "orange",
                    bg = "darkblue",
                    style = "italic",
                },
                left_sep = "block",
                right_sep = "block",
            },
            position = {
                provider = "position",
                hl = {
                    fg = "green",
                    bg = "darkblue",
                    style = "bold",
                },
                left_sep = "block",
                right_sep = "block",
            },
            line_percentage = {
                provider = "line_percentage",
                hl = {
                    fg = "aqua",
                    bg = "darkblue",
                    style = "bold",
                },
                left_sep = "block",
                right_sep = "block",
            },
            scroll_bar = {
                provider = "scroll_bar",
                hl = {
                    --fg = "yellow",
                    fg = "aqua",
                    style = "bold",
                },
            },
            vi_mode = {
                provider = '▊',
                left = {
                    provider = '▊',
                    --hl = vimode_hl,
                    hl = {
                        fg = "pink",
                        style = "bold",
                    },
                    --right_sep = ' '
                },
                right = {
                    provider = '▊',
                    --hl = vimode_hl,
                    hl = {
                        fg = "pink",
                        style = "bold",
                    },
                    left_sep = 'block'
                },
            },
        }

        local left = {
            c.vi_mode.left,
            c.vim_mode,
            c.line_percentage,
            c.position,
            c.gitBranch,
            c.gitDiffAdded,
            c.gitDiffRemoved,
            c.gitDiffChanged,
            c.separator,
        }

        local middle = {
            c.fileinfo,
            c.diagnostic_errors,
            c.diagnostic_warnings,
            c.diagnostic_info,
            c.diagnostic_hints,
        }

        local right = {
            c.lsp_client_names,
            c.file_type,
            c.file_size,
            --c.scroll_bar,
            c.vi_mode.right,
        }

        local components = {
            active = {
                left,
                middle,
                right,
            },
            inactive = {
                left,
                middle,
                right,
            },
        }

        feline.setup({
            components = components,
            theme = one_monokai,
            vi_mode_colors = vi_mode_colors,
        })
    end
}
