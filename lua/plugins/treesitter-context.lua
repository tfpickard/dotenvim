-- Sticky scope header: pins the enclosing function/class/block to the top of
-- the window so you always know where you are in long files. Pairs nicely with
-- the Snacks scope/chunk indent guides.
return {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    opts = {
        max_lines = 3, -- how many context lines to show at most
        multiline_threshold = 1, -- collapse multiline context to a single line
        trim_scope = "outer",
        separator = "─",
    },
    keys = {
        {
            "<leader>ux",
            "<cmd>TSContext toggle<cr>",
            desc = "Toggle Treesitter Context",
        },
        {
            "[x",
            function()
                require("treesitter-context").go_to_context(vim.v.count1)
            end,
            desc = "Jump to Context (upwards)",
        },
    },
}
