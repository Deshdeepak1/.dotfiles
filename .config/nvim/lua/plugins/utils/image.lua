---@module "lazy"
---@type LazySpec
return {
  "3rd/image.nvim",
  -- cond = false,
  enabled = false,
  lazy = false,
  -- event = "VeryLazy",
  build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
  opts = {
    backend = "kitty",
    processor = "magick_cli", -- or "magick_rock"
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        only_render_image_at_cursor_mode = "popup",
        floating_windows = true, -- if true, images will be rendered in floating markdown windows
        filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
        resolve_image_path = function(document_path, image_path, fallback)
          local working_dir = vim.fn.getcwd()
          -- Format image path for Obsidian notes
          local obsidian_client = require("obsidian").get_client()
          if working_dir:find(obsidian_client:vault_root().filename) then
            if image_path:find("|") then image_path = vim.split(image_path, "|")[1] end
            local assets_dir = "assets"
            local result = string.format("%s/%s/%s", obsidian_client:vault_root().filename, assets_dir, image_path)
            return result
          end
          -- Fallback to the default behavior
          return fallback(document_path, image_path)
        end,
      },
      neorg = {
        enabled = true,
        filetypes = { "norg" },
      },
      typst = {
        enabled = true,
        filetypes = { "typst" },
      },
      html = {
        enabled = false,
      },
      css = {
        enabled = false,
      },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
    editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
    tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
  },
}
