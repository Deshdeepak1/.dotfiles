---@type vim.lsp.Config
return {
  settings = {
    json = {
      validate = {
        enable = true,
      },
    },
  },
  before_init = function(_, config)
    -- can't assign new table because of
    -- https://github.com/neovim/neovim/issues/27740#issuecomment-1978629315
    ---@diagnostic disable-next-line: inject-field
    config.settings.json.schemas = require("schemastore").json.schemas()
  end,
}
