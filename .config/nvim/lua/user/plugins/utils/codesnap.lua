return {
    "mistricky/codesnap.nvim",
    build = "make",
    cmd = { "CodeSnap", "CodeSnapSave" },
    config = function()
        require("codesnap").setup({
            save_path = "~/Pictures/codesnaps",
        })
    end
}
