local function restart_lsp(name)
    vim.lsp.enable(name, false)
    vim.defer_fn(function()
        vim.lsp.enable(name)
    end, 100)
end

return {

    {

        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            ---@type vim.lsp.Config
            servers = {
                -- Servers listed here are auto-installed by LazyVim via
                -- mason-lspconfig (mason v2). Formatters/linters/DAPs go in
                -- lua/plugins/mason.lua ensure_installed instead.
                bashls = {},
                html = {},
                vtsls = {
                    settings = {
                        complete_function_calls = true,
                        vtsls = {
                            autoUseWorkspaceTsdk = true,
                        },
                        typescript = {
                            updateImportsOnFileMove = { enabled = "always" },
                            suggest = {
                                completeFunctionCalls = true,
                            },
                        },
                        javascript = {
                            suggest = {
                                completeFunctionCalls = true,
                            },
                        },
                    },
                },
                pyright = {
                    settings = {
                        python = {
                            analysis = {
                                -- "basic" keeps diagnostics useful without the
                                -- wall of noise "strict" produces in most repos.
                                -- Drop a pyrightconfig.json in a project to opt
                                -- that project back into strict checking.
                                typeCheckingMode = "basic",
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                            },
                        },
                    },
                    keys = {
                        {
                            "<leader>rf",
                            "<cmd>LspPyrightOrganizeImports<cr>",
                            desc = "Organize Imports",
                        },
                        {
                            "<leader>rr",
                            function()
                                restart_lsp("pyright")
                            end,
                            desc = "Restart Pyright",
                        },
                    },
                },
            },
        },
    },
}
