local function restart_lsp(name)
    vim.lsp.enable(name, false)
    vim.defer_fn(function()
        vim.lsp.enable(name)
    end, 100)
end

return {

    {
        {
            "tfpickard/pathcheck.nvim",
            enabled = false,
            -- dir = "~/src/pathcheck.nvim/",
            lazy = false,
            config = function()
                require("pathcheck").ensure_local_bin()
            end,
        },
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = {
            -- Formatters and linters to install
            ensure_installed = {
                -- formatters
                "shfmt", -- Bash/Zsh/Shell
                "clang-format", -- C/C++
                -- "cmake-format",           -- CMake
                "prettier", -- CSS
                -- "dockfmt",                -- Docker & Docker Compose
                "prettier", -- HTML
                -- "ini-fmt",                -- INI
                "prettier",
                "biome", -- JavaScript/TypeScript
                "prettier",
                "jq", -- JSON
                "latexindent", -- LaTeX
                "stylua", -- Lua
                -- "indent",                 -- Make
                "prettier",
                "mdformat", -- Markdown
                "black",
                "isort",
                "ruff", -- Python
                "rustfmt", -- Rust
                "taplo", -- TOML
                "prettier",
                "yamlfix", -- YAML

                -- linters
                "shellcheck", -- Bash/Zsh/Shell
                -- "clang-tidy",
                -- "cppcheck", -- C/C++
                "cmakelint", -- CMake
                "stylelint", -- CSS
                "hadolint", -- Docker & Docker Compose
                "htmlhint", -- HTML
                -- "ini-lint", -- INI
                "eslint",
                "biome", -- JavaScript/TypeScript
                "jsonlint", -- JSON
                -- "chktex", -- LaTeX
                "luacheck", -- Lua
                "checkmake", -- Make
                "markdownlint", -- Markdown
                "ruff",
                "pylint",
                "flake8",
                "mypy", -- Python
                -- "clippy", -- Rust
                "taplo", -- TOML
                "yamllint", -- YAML
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
