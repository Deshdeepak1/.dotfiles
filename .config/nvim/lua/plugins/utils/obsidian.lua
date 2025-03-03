return {
  "benatouba/obsidian.nvim",
  cond = false,
  version = "*",  -- recommended, use latest release instead of latest commit
  -- cond = false,
  lazy = true,
  -- ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  cmd = {"ObsidianQuickSwitch"},
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    -- refer to `:h file-pattern` for more examples
    "BufReadPre " .. vim.fn.expand("~") .. "/notes/Obsidian Vault/*.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/notes/Obsidian Vault/*.md",
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/notes/Obsidian Vault/",
      },
    },
    log_level = vim.log.levels.INFO,
    completion = {
      -- Set to false to disable completion.
      blink = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },
    new_notes_location = "current_dir",
    preferred_link_style = "wiki",
    disable_frontmatter = true,
    attachments = {
      img_folder = "assets",
    },
    templates = {
      folder = "templates",
    }
  },
}
