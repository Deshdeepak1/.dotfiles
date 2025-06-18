---@module "lazy"
---@type LazySpec
return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  cond = function()
    local _ = vim.fn.system("git rev-parse --is-inside-work-tree")
    return vim.v.shell_error == 0
  end,
  -- cond = false,
  opts = {},
  config = function()
    require("gitsigns").setup({
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true })

        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true })

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset" })
        map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage" })
        map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "StageBuffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = "ResetBuffer" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview" })
        map("n", "<leader>hP", gs.preview_hunk_inline, { desc = "PreviewInline" })
        map("n", "<leader>hB", function() gs.blame_line({ full = true }) end, { desc = "Blame" })
        map("n", "<leader>hb", gs.toggle_current_line_blame, { desc = "ToggleBlame" })
        map("n", "<leader>hd", gs.diffthis, { desc = "Diff" })
        map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "Diff~" })
        map("n", "<leader>hw", gs.toggle_word_diff, { desc = "ToggleWordDiff" })
        map("n", "<leader>hl", gs.toggle_linehl, { desc = "ToggleLine" })
        map("n", "<leader>ht", gs.toggle_deleted, { desc = "ToggleDeleted" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,
    })
  end,
}
