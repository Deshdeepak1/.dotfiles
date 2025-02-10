return {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    cond = false,
    -- lazy = false,
    ft = { 'org' },
    config = function()
        -- Setup orgmode
        require('orgmode').setup({
            org_agenda_files = '~/org/Agenda/**/*',
            org_default_notes_file = '~/org/refile.org',
            org_ellipsis = " ▼",
            org_startup_indented = true,
            org_hide_leading_stars = true,
            org_adapt_indentation = false,
            org_highlight_latex_and_related = "latex",
        })

        -- NOTE: If you are using nvim-treesitter with `ensure_installed = "all"` option
        -- add `org` to ignore_install
        -- require('nvim-treesitter.configs').setup({
        --   ensure_installed = 'all',
        --   ignore_install = { 'org' },
        -- })
    end,
}
