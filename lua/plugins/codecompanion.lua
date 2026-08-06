-- AI chat / inline assistant. Uses GitHub Copilot as the backing adapter
-- (you're already authed via copilot.lua), so no extra API keys are needed.
--
-- Reclaims the previously-dead <C-a> / <LocalLeader>a / ga keymaps that used
-- to point at CodeCompanion before it was removed from the stack.
return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    cmd = {
        "CodeCompanion",
        "CodeCompanionChat",
        "CodeCompanionActions",
        "CodeCompanionCmd",
    },
    keys = {
        {
            "<C-a>",
            "<cmd>CodeCompanionActions<cr>",
            mode = { "n", "v" },
            desc = "CodeCompanion Actions",
        },
        {
            "<LocalLeader>a",
            "<cmd>CodeCompanionChat Toggle<cr>",
            mode = { "n", "v" },
            desc = "CodeCompanion Chat (toggle)",
        },
        {
            "ga",
            "<cmd>CodeCompanionChat Add<cr>",
            mode = "v",
            desc = "CodeCompanion Add to Chat",
        },
    },
    init = function()
        -- Expand 'cc' into 'CodeCompanion' on the command line.
        vim.cmd([[cab cc CodeCompanion]])
    end,
    opts = {
        strategies = {
            chat = { adapter = "copilot" },
            inline = { adapter = "copilot" },
            cmd = { adapter = "copilot" },
        },
    },
}
