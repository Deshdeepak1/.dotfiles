local save_path = "~/Pictures/codesnaps"

---@module "lazy"
---@type LazySpec
return {
  "mistricky/codesnap.nvim",
  -- cond = false,
  build = "make",
  cmd = { "CodeSnap", "CodeSnapSave" },
  opts = {
    mac_window_bar = false,
    title = "CodeSnap.nvim",
    code_font_family = "CaskaydiaCove Nerd Font",
    watermark_font_family = "Pacifico",
    watermark = "",
    bg_theme = "default",
    breadcrumbs_separator = "/",
    has_breadcrumbs = true,
    has_line_number = true,
    show_workspace = false,
    min_width = 0,
    bg_x_padding = 10,
    bg_y_padding = 10,
    save_path = save_path,
  },
  init = function() vim.fn.mkdir(vim.fn.expand(save_path), "p") end,
}
