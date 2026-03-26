local function restart_lsp(name)
    vim.lsp.enable(name, false)
    vim.defer_fn(function()
        vim.lsp.enable(name)
    end, 100)
end

return {

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = {
            ensure_installed = {
                -- formatters
                "stylua",
                "shfmt",
                "biome",
                "black",
                "isort",
                "ruff",
                "mdformat",
                "latexindent",
                "taplo",
                "yamlfix",
                "rustfmt",

                -- diagnostics / linters
                "shellcheck",
                "cmakelint",
                "hadolint",
                "eslint",
                "jsonlint",
                "luacheck",
                "markdownlint",
                "mypy",
                "yamllint",
            },
        },
        config = function(_, opts)
            require("mason-tool-installer").setup(opts)
        end,
    },

    {

        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            ---@type vim.lsp.Config
            servers = {
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
                                typeCheckingMode = "strict",
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                            },
                        },
                    },
                    keys = {
                        { "<leader>rf", "<cmd>LspPyrightOrganizeImports<cr>", desc = "Organize Imports" },
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
