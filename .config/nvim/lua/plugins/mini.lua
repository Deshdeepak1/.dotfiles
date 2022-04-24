local st_ok, session = pcall(require, "mini.sessions")
if st_ok then
    session.setup(
        { directory = vim.fn.stdpath("data") .. "/sessions/",
            autoread = false,

        }
    )
end

local starter = require("mini.starter")
starter.setup(
    {
        evaluate_single = true,
        items = {
          starter.sections.sessions(5, false),
          starter.sections.recent_files(5, true),
          starter.sections.recent_files(5, false),
          starter.sections.builtin_actions(),
          -- starter.sections.telescope(),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(),
          starter.gen_hook.indexing('all', { 'Builtin actions' }),
          -- starter.gen_hook.padding(30, 2),
          starter.gen_hook.aligning("center", "center"),
        },
    }
)

vim.api.nvim_create_user_command(
    'SaveSession',
    function (input)
        session.write(input.args)
    end,
    {nargs=1, complete="file"}
)

vim.api.nvim_create_user_command(
    'DeleteSession',
    function (input)
        session.delete(input.args)
    end,
    {nargs=1, complete="file"}
)

