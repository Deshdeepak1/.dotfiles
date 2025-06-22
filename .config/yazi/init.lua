require("full-border"):setup()
require("git"):setup()
local catppuccin_theme = require("yatline-catppuccin"):setup("mocha")
require("yatline"):setup({
  theme = catppuccin_theme,
  show_background = false,

  display_header_line = true,
  display_status_line = true,

  component_positions = { "header", "tab", "status" },

  header_line = {
    left = {
      section_a = {
        { type = "line", custom = false, name = "tabs", params = { "left" } },
      },
      section_b = {},
      section_c = {},
    },
    right = {
      section_a = {
        -- { type = "string", custom = false, name = "date", params = { "%A, %d %B %Y" } },
      },
      section_b = {
        -- { type = "string", custom = false, name = "date", params = { "%X" } },
      },
      section_c = {
        { type = "string", custom = false, name = "tab_path" },
      },
    },
  },

  status_line = {
    left = {
      section_a = {
        { type = "string", custom = false, name = "tab_mode" },
      },
      section_b = {
        -- { type = "string", custom = false, name = "hovered_path" },
        -- { type = "string", custom = false, name = "hovered_name" },
        { type = "coloreds", custom = false, name = "githead" },
      },
      section_c = {
        -- { type = "coloreds", custom = false, name = "githead" },
        { type = "coloreds", custom = false, name = "count" },
      },
    },
    right = {
      section_a = {
        { type = "string", custom = false, name = "cursor_position" },
      },
      section_b = {
        -- { type = "string", custom = false, name = "cursor_percentage" },
        { type = "string", custom = false, name = "hovered_file_extension", params = { true } },
      },
      section_c = {
        { type = "string", custom = false, name = "hovered_size" },
        { type = "coloreds", custom = false, name = "permissions" },
      },
    },
  },
})
require("yatline-githead"):setup({
  theme = catppuccin_theme,
})
