lua << EOF
require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_position = "bottom",
    prompt_prefix = "🔎",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_defaults = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    shorten_path = true,
    winblend = 0,
    width = 0.75,
    preview_cutoff = 120,
    results_height = 1,
    results_width = 0.8,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  }
}
EOF

map <M-t> <cmd>lua require('telescope.builtin').live_grep()<cr>
map <M-f> <cmd>lua require('telescope.builtin').find_files()<cr>

" T is for Telescope
let g:which_key_map.T = {
    \ 'name' : '+Telescope',
    \ 'f' : [':Telescope find_files', 'Files'],
    \ 'g' : [':Telescope live_grep', 'Grep'],
    \ 'b' : [':Telescope buffers', 'Buffers'],
    \ 'h' : [':Telescope help_tags', 'Help'],
  \ }
let g:which_key_map.T.G = {
    \ 'name' : '+Git',
    \ 'f' : [':Telescope git_files', 'Files'],
    \ 'c' : [':Telescope git_commits', 'Commits'],
    \ 'b' : [':Telescope git_branches', 'Branches'],
    \ 's' : [':Telescope git_status', 'Status'],
  \ }
