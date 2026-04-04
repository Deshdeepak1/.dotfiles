---@module "lazy"
---@type LazySpec
return {
  {
    "github/copilot.vim",
    lazy = false,
    cmd = { "Copilot" },
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })
    end,
  },
}
