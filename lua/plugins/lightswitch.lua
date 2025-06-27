return {
    "markgandolfo/lightswitch.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
        require("lightswitch").setup({
            toggles = {
                {
                    name = "Copilot",
                    enable_cmd = "Copilot enable",
                    disable_cmd = "Copilot disable",
                    state = true, -- Initially enabled
                },
                {
                    name = "LSP",
                    enable_cmd = ":LspStart<CR>",
                    disable_cmd = ":LspStop<CR>",
                    state = false, -- Initially disabled
                },
                {
                    name = "Treesitter",
                    enable_cmd = ":TSEnable<CR>",
                    disable_cmd = ":TSDisable<CR>",
                    state = true, -- Initially enabled
                },
                {
                    name = "Diagnostics",
                    enable_cmd = "lua vim.diagnostic.enable()",
                    disable_cmd = "lua vim.diagnostic.disable()",
                    state = true,
                },
                {
                    name = "Formatting",
                    enable_cmd = "lua vim.g.format_on_save = true",
                    disable_cmd = "lua vim.g.format_on_save = false",
                    state = false,
                },
            },
        })
    end,
}
