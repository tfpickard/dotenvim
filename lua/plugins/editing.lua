return {
    "sqve/sort.nvim",
    keys = {
        {
            mode = "n",
            "go",
            "<esc><cmd>sort<cr>",
            desc = "sort",
        },
        {
            mode = "v",
            "go",
            "<esc><cmd>sort<cr>",
            desc = "sort",
        },
        -- vnoremap <silent> go <esc><cmd>sort<cr>}
    },
    -- optional setup for overriding defaults.
    config = function()
        require("sort").setup({
            -- Input configuration here.
            -- Refer to the configuration section below for options.
            -- List of delimiters, in descending order of priority, to automatically
            -- sort on.
            delimiters = {
                ",",
                "|",
                ";",
                ":",
                "s", -- Space
                "t", -- Tab
            },
        })
    end,
}
