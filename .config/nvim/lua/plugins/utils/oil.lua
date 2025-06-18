---@module "lazy"
---@type LazySpec
return {
  "stevearc/oil.nvim",
  -- cond = false,
  -- cond = not vim.g.started_by_firenvim,
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  keys = {
    {
      "<leader>e",
      function() require("oil").toggle_float() end,
      desc = "Oil",
    },
  },
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    columns = {
      "icon",
      -- "permissions",
    },
    skip_confirm_for_simple_edits = true,
    float = {
      max_height = 40,
      max_width = 100,
      win_options = { winblend = 0 },
      -- override = function(conf)
      --     return conf
      -- end,
    },
    keymaps = {
      ["Q"] = "actions.close",
      ["<leader>t"] = "actions.open_terminal",
      ["<leader>T"] = {
        desc = "Toggle detail view",
        callback = function()
          local oil = require("oil")
          local config = require("oil.config")
          if #config.columns == 1 then
            oil.set_columns({ "icon", "permissions", "size", "mtime" })
          else
            oil.set_columns({ "icon" })
          end
        end,
      },
      ["gm"] = {
        desc = "Open entry in mpv",
        callback = function()
          local oil = require("oil")
          local cwd = oil.get_current_dir()
          local entry = oil.get_cursor_entry()
          if cwd and entry then
            local fpath = string.format("%s/%s", cwd, entry.name)
            vim.system({ "mpv", fpath })
          end
        end,
      },
      ["gf"] = {
        desc = "Fdur",
        callback = function()
          local oil = require("oil")
          local cwd = oil.get_current_dir()
          local entry = oil.get_cursor_entry()
          local bnr, line_num, col_num = unpack(vim.fn.getcurpos())
          local ns_id = vim.api.nvim_create_namespace("fdur")
          if cwd and entry then
            local fpath = string.format("%s/%s", cwd, entry.name)
            local cmd = "fdur " .. vim.fn.fnameescape(fpath)
            vim.system({ "fish", "-c", cmd }, { text = false }, function(obj)
              local fdur = obj.stdout:gsub("\n", "")
              -- print( entry.name .. " :- " .. t)
              vim.schedule(
                function()
                  vim.api.nvim_buf_set_extmark(bnr, ns_id, line_num - 1, col_num, {
                    id = entry.id,
                    virt_text = { { fdur, "LspDiagnosticsVirtualTextInformation" } },
                  })
                end
              )
            end)
          end
        end,
      },
      ["gF"] = {
        desc = "Fdur list",
        callback = function()
          local oil = require("oil")
          local cwd = oil.get_current_dir()
          local bnr = vim.fn.bufnr()
          local ns_id = vim.api.nvim_create_namespace("fdur")
          if cwd then
            vim.system({ "fish", "-c", "lsfdur_nocolor" }, { text = false }, function(obj)
              local lines = vim.split(obj.stdout:gsub("\n$", ""), "\n")
              -- print(vim.inspect(lines))
              local rdurs = {}
              for _, line in ipairs(lines) do
                local fname, rdur = unpack(vim.split(line, "\t"))
                rdurs[fname] = rdur
              end
              vim.schedule(function()
                local line_nums = vim.fn.line("$")
                for line_num = 1, line_nums do
                  local entry = oil.get_entry_on_line(bnr, line_num)
                  -- print(vim.inspect(entry))
                  if entry then
                    vim.api.nvim_buf_set_extmark(bnr, ns_id, line_num - 1, 0, {
                      id = entry.id,
                      virt_text = { { rdurs[entry.name], "LspDiagnosticsVirtualTextInformation" } },
                    })
                  end
                end
              end)
            end)
          end
        end,
      },
      ["gd"] = {
        desc = "Recursive size",
        callback = function()
          local oil = require("oil")
          local cwd = oil.get_current_dir()
          local entry = oil.get_cursor_entry()
          local bnr, line_num, col_num = unpack(vim.fn.getcurpos())
          local ns_id = vim.api.nvim_create_namespace("du")
          if cwd and entry then
            local fpath = string.format("%s/%s", cwd, entry.name)
            -- local cmd = "fdur " .. vim.fn.fnameescape(fpath)
            vim.system({ "du", "-sh", fpath }, { text = false }, function(obj)
              local rsize = obj.stdout:gsub("\n", ""):match("(.+)\t")
              -- print( entry.name .. " :- " .. t)
              vim.schedule(
                function()
                  vim.api.nvim_buf_set_extmark(bnr, ns_id, line_num - 1, col_num, {
                    id = entry.id,
                    virt_text = { { rsize, "LspDiagnosticsVirtualTextWarning" } },
                  })
                end
              )
            end)
          end
        end,
      },
      ["gD"] = {
        desc = "Recursive size list",
        callback = function()
          local oil = require("oil")
          local cwd = oil.get_current_dir()
          local bnr = vim.fn.bufnr()
          local ns_id = vim.api.nvim_create_namespace("du")
          if cwd then
            vim.system({ "du", "-hd1" }, { text = false }, function(obj)
              local lines = vim.split(obj.stdout:gsub("\n$", ""), "\n")
              local rsizes = {}
              for _, line in ipairs(lines) do
                local rsize, fname = unpack(vim.split(line, "\t"))
                if fname == "." then
                  print("Total: ", rsize)
                else
                  fname = fname:sub(3)
                  rsizes[fname] = rsize
                end
              end
              vim.schedule(function()
                local line_nums = vim.fn.line("$")
                for line_num = 1, line_nums do
                  local entry = oil.get_entry_on_line(bnr, line_num)
                  -- print(vim.inspect(entry))
                  if entry then
                    vim.api.nvim_buf_set_extmark(bnr, ns_id, line_num - 1, 0, {
                      id = entry.id,
                      virt_text = { { rsizes[entry.name], "LspDiagnosticsVirtualTextWarning" } },
                    })
                  end
                end
              end)
            end)
          end
        end,
      },
    },
  },
}
