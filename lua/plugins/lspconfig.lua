return {

    {
        {
            "tfpickard/pathcheck.nvim",
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
            print("hi!")
        end,
    },

    {

        "neovim/nvim-lspconfig",
        dependencies = {
            "jose-elias-alvarez/typescript.nvim",
            init = function()
                require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
                    vim.keymap.set(
                        "n",
                        "<leader>cR",
                        "TypescriptRenameFile",
                        { desc = "Rename File", buffer = buffer }
                    )
                    -- Python specific keymaps
                    vim.keymap.set(
                        "n",
                        "<leader>rf",
                        ":PyrightOrganizeImports<CR>",
                        { desc = "Organize Imports", buffer = buffer }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>rr",
                        ":PyrightRestart<CR>",
                        { desc = "Restart Pyright", buffer = buffer }
                    )
                end)
            end,
        },
        ---@class PluginLspOpts
        opts = {
            ---@type lspconfig.options
            servers = {
                -- tsserver will be automatically installed with mason and loaded with lspconfig
                tsserver = {},
                pyright = {},
            },
            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
            setup = {
                -- example to setup with typescript.nvim
                tsserver = function(_, opts)
                    require("typescript").setup({ server = opts })
                    return true
                end,
                -- example to setup with pyright
                pyright = function(_, opts)
                    -- Customize pyright settings here
                    opts.settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = "strict",
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                            },
                        },
                    }
                    return true
                end,
                -- ["*"] = function(server, opts) end,
            },
        },
    },
}
