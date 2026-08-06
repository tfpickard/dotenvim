return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "BufReadPost",
        -- NOTE: no inline <C-J>/<C-K> accept/dismiss keymaps here. With
        -- vim.g.ai_cmp = true (options.lua), Copilot suggestions are surfaced
        -- through blink.cmp (accept with <Tab>), so those inline maps were dead
        -- and also collided with the <C-j>/<C-k> window-navigation maps in
        -- keymaps.lua. Set vim.g.ai_cmp = false if you want inline ghost text back.
        opts = {
            -- suggestion = { enabled = false },
            -- panel = { enabled = false },
            -- filetypes = {
            -- markdown = true,
            -- help = true,
            -- },
        },
        config = function(_, opts)
            -- if vim.g.has_internet == false then
            -- vim.g.copilot_enabled = false
            -- return
            -- end
            require("copilot").setup(opts)
            vim.g.copilot_enabled = true
            vim.g.copilot_no_tab_map = true
        end,
    },
}
