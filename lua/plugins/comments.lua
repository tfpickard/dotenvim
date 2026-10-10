--          ╭─────────────────────────────────────────────────────────╮
--          │             Now this is a sexy comment box              │
--          ╰─────────────────────────────────────────────────────────╯
-- (The dead `s1n7ax/nvim-comment-frame` spec that used to sit here was
-- `enabled = false` with its config commented out, so it only cost startup
-- resolution time. Removed.)
--
-- NOTE: comment-box.nvim is stable but has not been pushed since 2024-08.
-- It's purely cosmetic and has no active successor, so it stays for now --
-- worth revisiting if it ever breaks on a Neovim API change.
return {
    "LudoPinelli/comment-box.nvim",
    keys = {
        { mode = { "n", "v" }, "<Leader>cb", "<Cmd>CBccbox<CR>", desc = "Comment box title" },
        { mode = { "n", "v" }, "<Leader>ct", "<Cmd>CBllline<CR>", desc = "Comment box named parts" },
        { mode = "n", "<Leader>cl", "<Cmd>CBline<CR>", desc = "Comment box simple line" },
        { mode = { "n", "v" }, "<Leader>cm", "<Cmd>CBllbox14<CR>", desc = "Comment box marked" },
    },
    opts = {},
}
