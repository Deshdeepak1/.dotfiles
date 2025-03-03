return {
  "Tweekism/markdown-preview.nvim",
  cond = not vim.g.started_by_firenvim,
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  -- event = "VeryLazy",
  -- cmd = { "MarkdownPreviewToggle" },
  build = "cd app && npm install && git restore .",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  ft = { "markdown" },
}
