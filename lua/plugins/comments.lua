--          ╭─────────────────────────────────────────────────────────╮
--          │             Now this is a sexy comment box              │
--          ╰─────────────────────────────────────────────────────────╯
return {
    {
        "s1n7ax/nvim-comment-frame",
        enabled = false,
        dependencies = {
            { "nvim-treesitter" },
        },
        -- config = function()
        --     require("nvim-comment-frame").setup()
        -- end,
    },
    {
        "LudoPinelli/comment-box.nvim",
        keys = {
            -- Titles
            { mode = { "n", "v" }, "<Leader>cb", "<Cmd>CBccbox<CR>", desc = "Comment box title" },
            -- Named parts
            {
                mode = { "n", "v" },
                "<Leader>ct",
                "<Cmd>CBllline<CR>",
                desc = "Comment box named parts",
            },
            -- Simple line
            { mode = "n", "<Leader>cl", "<Cmd>CBline<CR>", desc = "comment box simple line" },
            -- keymap("i", "<M-l>", "<Cmd>CBline<CR>", opts) -- To use in Insert Mode
            -- Marked comments
            {
                mode = { "n", "v" },
                "<Leader>cm",
                "<Cmd>CBllbox14<CR>",
                "comment box narked comments",
            },
            -- Removing a box is simple enough with the command (CBd), but if you
            -- use it a lot:
            -- keymap({ "n", "v" }, "<Leader>cd", "<Cmd>CBd<CR>", opts)
        },
    },
}
