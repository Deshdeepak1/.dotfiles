local zone = os.date("%z")
---@diagnostic disable-next-line: param-type-mismatch
local formatted_zone = string.format("%s:%s", zone:sub(1, 3), zone:sub(4, 5))

---@module "lazy"
---@type LazySpec
return {
  {
    "obsidian-nvim/obsidian.nvim",
    -- version = "*", -- recommended, use latest release instead of latest commit
    -- cond = false,
    -- ft = "markdown",
    cmd = { "Obsidian" },
    keys = {
      { "<leader>nf", "<cmd>Obsidian quick_switch<cr>", desc = "QuickSwitch" },
      { "<leader>n/", "<cmd>Obsidian search<cr>", desc = "Search" },
      { "<leader>nb", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
      { "<leader>nN", "<cmd>Obsidian new_from_template<cr>", desc = "NewFromTemplate" },
      { "<leader>ni", "<cmd>Obsidian template<cr>", desc = "InsertTemplate" },
      "<leader>nn",
      "<leader>nL",
      "<leader>nE",
      { "<leader>nl", "<cmd>Obsidian link<cr>", desc = "Link", mode = { "x" } },
      { "<leader>nt", "<cmd>Obsidian tags<cr>", desc = "Tags" },
      { "<leader>nT", "<cmd>Obsidian toc<cr>", desc = "TOC" },
      { "<leader>ne", "<cmd>Obsidian follow_link<cr>", desc = "Edit" },
      { "<leader>nv", "<cmd>Obsidian follow_link vsplit<cr>", desc = "Edit Vsplit" },
      { "<leader>ns", "<cmd>Obsidian follow_link hsplit<cr>", desc = "Edit Hsplit" },
      { "<leader>no", "<cmd>Obsidian open<cr>", desc = "Open" },
      { "<leader>nr", "<cmd>Obsidian rename<cr>", desc = "Rename" },
      { "<leader>np", "<cmd>Obsidian paste_img<cr>", desc = "PasteImg" },
      { "<leader>ndt", "<cmd>Obsidian today<cr>", desc = "Today" },
      { "<leader>ndT", "<cmd>Obsidian tomorrow<cr>", desc = "Tomorrow" },
      { "<leader>ndy", "<cmd>Obsidian yesterday<cr>", desc = "Yesterday" },
      { "<leader>ndo", ":Obsidian today ", desc = "Offset" },
      { "<leader>ndd", ":Obsidian dailies ", desc = "OffsetTillPick" },
    },
    event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    -- refer to `:h file-pattern` for more examples
      -- stylua: ignore start
      "BufReadPre " .. vim.fn.resolve(vim.fn.expand("~/notes"))  .. "/ObsidianVault/*.md",
      "BufNewFile " .. vim.fn.resolve(vim.fn.expand("~/notes")) .. "/ObsidianVault/*.md",
      -- stylua: ignore end
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
      -- "folke/snacks.nvim",
      "ilya-m32/snacks.nvim",
      "saghen/blink.cmp",
      "nvim-treesitter/nvim-treesitter",
    },
    ---@module "obsidian"
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/notes/ObsidianVault/",
        },
      },
      log_level = vim.log.levels.INFO,

      completion = {
        -- Set to false to disable completion.
        nvim_cmp = false,
        blink = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },

      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function() return require("obsidian").util.gf_passthrough() end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>nc"] = {
          action = function() return require("obsidian").util.toggle_checkbox() end,
          opts = { buffer = true },
        },
        -- Smart action depending on context: follow link, show notes with tag, or toggle checkbox.
        ["<cr>"] = {
          action = function() return require("obsidian").util.smart_action() end,
          opts = { buffer = true, expr = true },
        },
      },

      new_notes_location = "current_dir",

      -- Optional, customize how note IDs are generated given an optional title.
      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        local id
        if title == nil then
          id = tostring(os.time())
        else
          id = title
        end
        return id
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        -- local suffix = ""
        -- if title ~= nil then
        --   -- If title is given, transform it into valid file name.
        --   suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        -- else
        --   -- If title is nil, just add 4 random uppercase letters to the suffix.
        --   for _ = 1, 4 do
        --     suffix = suffix .. string.char(math.random(65, 90))
        --   end
        -- end
        -- return tostring(os.time()) .. "-" .. suffix
      end,

      -- Optional, customize how note file names are generated given the ID, target directory, and title.
      ---@param spec { id: string, dir: obsidian.Path, title: string|? }
      ---@return string|obsidian.Path The full path to the new note.
      note_path_func = function(spec)
        -- This is equivalent to the default behavior.
        local path = spec.dir / tostring(spec.id)
        -- local path = spec.dir / spec.title
        return path:with_suffix(".md")
      end,

      preferred_link_style = "wiki",
      disable_frontmatter = false,

      -- Optional, alternatively you can customize the frontmatter data.
      ---@return table
      note_frontmatter_func = function(note)
        -- Add the title of the note as an alias.
        -- if note.title then note:add_alias(note.title) end

        local out = {
          -- id = note.id,
          aliases = note.aliases,
          tags = note.tags,
        }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        out.modified = os.date("%Y-%m-%dT%H:%M:%S") .. formatted_zone
        if out.created == nil then out.created = out.modified end

        return out
      end,

      -- Optional, for templates (see below).
      templates = {
        folder = "templates/core",
        date_format = "%Y-%m-%dT%H:%M:%S" .. formatted_zone,
      },

      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
        name = "snacks.pick",
        -- Optional, configure key mappings for the picker. These are the defaults.
        -- Not all pickers support all mappings.
        note_mappings = {
          -- Create a new note from your query.
          new = "<C-x>",
          -- Insert a link to the selected note.
          insert_link = "<C-l>",
        },
        tag_mappings = {
          -- Add tag(s) to current note.
          tag_note = "<C-x>",
          -- Insert a tag at the current location.
          insert_tag = "<C-l>",
        },
      },

      sort_by = "modified",
      sort_reversed = true,
      search_max_lines = 1000,
      open_notes_in = "current",

      callbacks = {
        -- Runs at the end of `require("obsidian").setup()`.
        ---@param client obsidian.Client
        post_setup = function(client) end,

        -- Runs anytime you enter the buffer for a note.
        ---@param client obsidian.Client
        ---@param note obsidian.Note
        enter_note = function(client, note) end,

        -- Runs anytime you leave the buffer for a note.
        ---@param client obsidian.Client
        ---@param note obsidian.Note
        leave_note = function(client, note) end,

        -- Runs right before writing the buffer for a note.
        ---@param client obsidian.Client
        ---@param note obsidian.Note
        pre_write_note = function(client, note) end,

        -- Runs anytime the workspace is set/changed.
        ---@param client obsidian.Client
        ---@param workspace obsidian.Workspace
        post_set_workspace = function(client, workspace) end,
      },

      -- Optional, configure additional syntax highlighting / extmarks.
      -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
      ui = {
        enable = true, -- set to false to disable all additional syntax features
        update_debounce = 200, -- update delay after a text change (in milliseconds)
        max_file_length = 5000, -- disable UI features for files with more than this many lines
        -- Define how various check-boxes are displayed
        checkboxes = {
          -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          ["!"] = { char = "", hl_group = "ObsidianImportant" },
          -- Replace the above with this if you don't have a patched font:
          -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
          -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

          -- You can also add more custom ones...
        },
        -- Use bullet marks for non-checkbox lists.
        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        -- Replace the above with this if you don't have a patched font:
        -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        block_ids = { hl_group = "ObsidianBlockID" },
        hl_groups = {
          -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
          ObsidianTodo = { bold = true, fg = "#f78c6c" },
          ObsidianDone = { bold = true, fg = "#89ddff" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianImportant = { bold = true, fg = "#d73128" },
          ObsidianBullet = { bold = true, fg = "#89ddff" },
          ObsidianRefText = { underline = true, fg = "#c792ea" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#89ddff" },
          ObsidianBlockID = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
        },
      },

      attachments = {
        img_folder = "assets",
      },
    },
    config = function(_, opts)
      local obsidian = require("obsidian")
      obsidian.setup(opts)
      local log = require("obsidian.log")
      local util = require("obsidian.util")
      local client = obsidian.get_client()

      vim.api.nvim_create_user_command("ObsidianNewWithTemplate", function(data)
        if not client:templates_dir() then
          log.err("Templates folder is not defined or does not exist")
          return
        end
        local title
        if data.args ~= nil and string.len(data.args) > 0 then
          title = util.strip_whitespace(data.args)
        else
          title = util.input("Enter title or path (optional): ", { completion = "file" })
          if not title then
            log.warn("Aborted")
            return
          elseif title == "" then
            title = nil
          end
        end
        note = client:create_note({ title = title, no_write = true })
        client:open_note(note, { sync = true })
        client:write_note_to_buffer(note, { template = "Basic" })
      end, { nargs = "?" })
      vim.keymap.set("n", "<leader>nn", ":ObsidianNewWithTemplate<cr>", { desc = "New" })

      vim.api.nvim_create_user_command("ObsidianLinkNewWithTemplate", function(data)
        local viz = util.get_visual_selection()
        if not viz then
          log.err("ObsidianLink must be called with visual selection")
          return
        elseif #viz.lines ~= 1 then
          log.err("Only in-line visual selections allowed")
          return
        end

        local line = assert(viz.lines[1])

        local title
        if data.args ~= nil and string.len(data.args) > 0 then
          title = util.strip_whitespace(data.args)
        else
          title = util.input("Enter title or path (optional): ", { completion = "file" })
          if not title then
            log.warn("Aborted")
            return
          elseif title == "" then
            title = viz.selection
          end
        end

        local note = client:create_note({ title = title, no_write = true })

        local new_line = string.sub(line, 1, viz.cscol - 1)
          .. client:format_link(note, { label = title })
          .. string.sub(line, viz.cecol + 1)

        vim.api.nvim_buf_set_lines(0, viz.csrow - 1, viz.csrow, false, { new_line })

        client:open_note(note, { sync = true })
        client:write_note_to_buffer(note, { template = "Basic" })
      end, { nargs = "?", range = true })
      vim.keymap.set("x", "<leader>nL", ":ObsidianLinkNewWithTemplate<cr>", { desc = "LinkNew" })

      vim.api.nvim_create_user_command("ObsidianExtractNoteWithTemplate", function(data)
        local viz = util.get_visual_selection()
        if not viz then
          log.err("ObsidianExtractNote must be called with visual selection")
          return
        end

        local content = vim.split(viz.selection, "\n", { plain = true })

        local title
        if data.args ~= nil and string.len(data.args) > 0 then
          title = util.strip_whitespace(data.args)
        else
          title = util.input("Enter title or path (optional): ", { completion = "file" })
          if not title then
            log.warn("Aborted")
            return
          elseif title == "" then
            title = nil
          end
        end
        -- create the new note.
        local note = client:create_note({ title = title, no_write = true })

        -- replace selection with link to new note
        local link = client:format_link(note)
        vim.api.nvim_buf_set_text(0, viz.csrow - 1, viz.cscol - 1, viz.cerow - 1, viz.cecol, { link })
        client:update_ui(0)

        -- add the selected text to the end of the new note
        client:open_note(note, { sync = true })
        client:write_note_to_buffer(note, { template = "Basic" })
        vim.api.nvim_buf_set_lines(0, -2, -2, false, content)
      end, { nargs = "?", range = true })

      vim.keymap.set("x", "<leader>nE", ":ObsidianExtractNoteWithTemplate<cr>", { desc = "Extract" })
    end,
  },
}
