---@param item snacks.picker.Item
local function format_filename(item, picker)
  ---@type snacks.picker.Highlight[]
  local ret = {}
  if not item.file then
    return ret
  end
  local path = Snacks.picker.util.path(item) or item.file
  -- path = Snacks.picker.util.truncpath(path, picker.opts.formatters.file.truncate or 40, { cwd = picker:cwd() })
  path = vim.fn.fnamemodify(path, ":~:.")
  local name, cat = path, "file"
  if item.buf and vim.api.nvim_buf_is_loaded(item.buf) then
    name = vim.bo[item.buf].filetype
    cat = "filetype"
  elseif item.dir then
    cat = "directory"
  end

  if picker.opts.icons.files.enabled ~= false then
    local icon, hl = Snacks.util.icon(name, cat, {
      fallback = picker.opts.icons.files,
    })
    if item.dir and item.open then
      icon = picker.opts.icons.files.dir_open
    end
    icon = Snacks.picker.util.align(icon, picker.opts.formatters.file.icon_width or 2)
    ret[#ret + 1] = { icon, hl, virtual = true }
  end

  local base_hl = item.dir and "SnacksPickerDirectory" or "SnacksPickerFile"
  local function is(prop)
    local it = item
    while it do
      if it[prop] then
        return true
      end
      it = it.parent
    end
  end

  if is("ignored") then
    base_hl = "SnacksPickerPathIgnored"
  elseif is("hidden") then
    base_hl = "SnacksPickerPathHidden"
  elseif item.filename_hl then
    base_hl = item.filename_hl
  end
  local dir_hl = "SnacksPickerDir"

  if picker.opts.formatters.file.filename_only then
    path = vim.fn.fnamemodify(item.file, ":t")
    ret[#ret + 1] = { path, base_hl, field = "file" }
  else
    local dir, base = path:match("^(.*)/(.+)$")
    if base and dir then
      if picker.opts.formatters.file.filename_first then
        ret[#ret + 1] = { base, base_hl, field = "file" }
        ret[#ret + 1] = { " " }
        ret[#ret + 1] = { dir, dir_hl, field = "file" }
      else
        ret[#ret + 1] = { dir .. "/", dir_hl, field = "file" }
        ret[#ret + 1] = { base, base_hl, field = "file" }
      end
    else
      ret[#ret + 1] = { path, base_hl, field = "file" }
    end
  end
  if item.pos and item.pos[1] > 0 then
    ret[#ret + 1] = { ":", "SnacksPickerDelim" }
    ret[#ret + 1] = { tostring(item.pos[1]), "SnacksPickerRow" }
    if item.pos[2] > 0 then
      ret[#ret + 1] = { ":", "SnacksPickerDelim" }
      ret[#ret + 1] = { tostring(item.pos[2]), "SnacksPickerCol" }
    end
  end
  ret[#ret + 1] = { " " }
  if item.type == "link" then
    local real = uv.fs_realpath(item.file)
    local broken = not real
    real = real or uv.fs_readlink(item.file)
    if real then
      ret[#ret + 1] = { "-> ", "SnacksPickerDelim" }
      ret[#ret + 1] =
        { Snacks.picker.util.truncpath(real, 20), broken and "SnacksPickerLinkBroken" or "SnacksPickerLink" }
      ret[#ret + 1] = { " " }
    end
  end
  return ret
end

return {
  "folke/snacks.nvim",
  -- cond = false,
  cond = not vim.g.started_by_firenvim,
  -- priority = 1000,
  lazy = false,
  -- event = "VeryLazy",
  ---@module 'snacks'
  ---@type snacks.Config
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    animate = { enabled = false },
    bigfile = { enabled = true, notify = false },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          {
            icon = " ",
            key = "r",
            desc = "Recent Files",
            action = ":lua Snacks.dashboard.pick('oldfiles', { filter = { cwd = true }})",
          },
          { icon = " ", key = "R", desc = "Recent Files Global", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      formats = {
        key = function(item)
          return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
        end,
        file = function(item, ctx)
          local fname = vim.fn.fnamemodify(item.file, ":~:.")
          fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
          if #fname > ctx.width then
            local dir = vim.fn.fnamemodify(fname, ":h")
            local file = vim.fn.fnamemodify(fname, ":t")
            if dir and file then
              file = file:sub(-(ctx.width - #dir - 2))
              fname = dir .. "/…" .. file
            end
          end
          local dir, file = fname:match("^(.*)/(.+)$")
          return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
        end,
      },
      sections = {
        { section = "header" },
        { icon = " ", title = "Recent Files", padding = 1 },
        { section = "recent_files", cwd = true, limit = 5, padding = 1 },
        { icon = " ", title = "Projects", padding = 1 },
        { section = "projects", padding = 1 },
        { icon = " ", title = "Keymaps", padding = 1 },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
    explorer = { enabled = false },
    indent = {
      enabled = true,
      indent = { char = "▏", enabled = true, only_scope = false, only_current = false },
      animate = { enabled = false },
      scope = { char = "▏", enabled = true, only_current = true },
      chunk = { enabled = false },
      ---@diagnostic disable-next-line: unused-local
      filter = function(buf)
        return vim.env.USER ~= "deshdeep" and vim.bo[buf].buftype ~= "help"
      end,
    },
    input = { enabled = false },
    notifier = { enabled = true, top_down = false },
    picker = {
      enabled = true,
    },
    profiler = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = {
      enabled = false,
      left = { "fold", "mark", "sign", "git" },
      right = {},
    },
    words = { enabled = false },
  },
  keys = {
    -- stylua: ignore start
    -- Files
    { "<leader>ff", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fr", function() Snacks.picker.recent({filter = {cwd = true}}) end, desc = "Recent" },
    { "<leader>fR", function() Snacks.picker.recent() end, desc = "Recent Global" },
    ---@diagnostic disable-next-line: assign-type-mismatch
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    -- Grep
    { "<leader>f/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>fG", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>fL", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- Git
    { "<leader>fgf", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fgb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>fg/", function() Snacks.picker.git_grep() end, desc = "Git grep" },
    { "<leader>fgs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>fgd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>fgS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>fgl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>fgL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>fgF", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- LSP
    { "<leader>fld", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "<leader>flD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "<leader>flr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "<leader>flI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "<leader>flt", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
    { "<leader>fls", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>flS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    -- Find
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>fd", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>fD", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>f:", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>fH", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>fi", function() Snacks.picker.icons() end, desc = "Icons" },
    -- stylua: ignore end
    {
      "<leader>fp",
      function()
        Snacks.picker.projects({
          dev = { "~/labs/repo/" },
          filter = { paths = { [vim.fn.stdpath("data")] = false } },
          format = format_filename,
        })
      end,
      desc = "Projects",
    },
    -- stylua: ignore start
    { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>fj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>fq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>fm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>fM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>fu", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>fC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- Others
    { "<leader>br", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>H",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>tn", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<leader>tz",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<C-\\>",      function() Snacks.terminal() end, desc = "Toggle Terminal", mode = {"n", "t"} },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "]r",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[r",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    -- stylua: ignore end
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        -- vim.print = _G.dd -- Override print to use snacks for `:=` command
        Snacks.toggle.diagnostics():map("<leader>td")
        Snacks.toggle.indent():map("<leader>ti")
        Snacks.toggle.dim():map("<leader>tD")
        Snacks.toggle.treesitter():map("<leader>tT")
        Snacks.toggle.words():map("<leader>tW")
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "OilActionsPost",
      callback = function(event)
        if event.data.actions.type == "move" then
          Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
      end,
    })
    vim.cmd([[highlight SnacksIndent guifg=#313245]])
  end,
}
