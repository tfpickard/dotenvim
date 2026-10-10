-- Mason v2 (mason-org/mason.nvim) auto-install setup.
--
-- How auto-install works now:
--   * LSP servers: any server configured under nvim-lspconfig `opts.servers`
--     is auto-installed by LazyVim via mason-lspconfig (unless `mason = false`).
--     Don't list servers here.
--   * Everything else (formatters, linters, DAP, extra tools): add the mason
--     package name to `ensure_installed` below. LazyVim's mason `config`
--     installs them on startup. Entries merge (opts_extend) with the ones
--     contributed by LazyVim extras (stylua, shfmt, black, prettier,
--     gofumpt, codelldb, ...), so only list things no extra provides.
--
-- IMPORTANT: do NOT define a `config` function in this spec. That would
-- replace LazyVim's mason config, which is what actually performs the
-- ensure_installed auto-install (this exact bug previously disabled all
-- auto-installation in this config).
return {
    "mason-org/mason.nvim",
    opts = {
        install_root_dir = vim.fn.stdpath("data") .. "/mason",
        PATH = "append", -- ensure mason/bin is on PATH

        -- Only list tools that something actually *uses*. A linter in
        -- ensure_installed that is not registered with nvim-lint (or used by
        -- an LSP) is downloaded and then never run -- pure disk cost.
        --
        -- Verified wired at runtime:
        --   nvim-lint -> cmakelint, fish, golangcilint, hadolint, markdownlint-cli2
        --   conform   -> biome-check, black, fish_indent, gofumpt, goimports,
        --                markdown-toc, markdownlint-cli2, prettier, shfmt, stylua
        -- All of those are already contributed by LazyVim extras, so this list
        -- only needs the extras' gaps.
        --
        -- Removed as unwired/redundant (each was installed but never invoked):
        --   jsonlint  -> jsonls validates JSON against SchemaStore
        --   luacheck  -> lua_ls already provides Lua diagnostics
        --   yamllint  -> yamlls validates against SchemaStore
        --   yamlfix   -> prettier formats YAML
        --   mdformat  -> markdownlint-cli2 + prettier + markdown-toc do markdown
        --   eslint_d  -> the typescript.biome extra uses biome-check instead
        --   checkmake -> not registered with nvim-lint
        --   mypy      -> pyright already type-checks (typeCheckingMode = basic)
        --   isort     -> not registered with conform
        --   latexindent -> no LaTeX filetype/extra is enabled
        -- Re-add any of these *together with* the nvim-lint/conform wiring that
        -- makes it run, otherwise it will silently do nothing again.
        ensure_installed = {
            -- Used by bash-language-server for shell diagnostics.
            "shellcheck",
            -- Registered with nvim-lint for dockerfile.
            "hadolint",
        },
    },
    config = nil, -- explicit: use LazyVim's config (see note above)
    init = function()
        -- Link newly installed mason tools into ~/.local/share/nvim/bin
        -- (moved here from the old custom `config` so it no longer clobbers
        -- LazyVim's installer). Runs after every successful install and once
        -- shortly after startup for tools installed while nvim was closed.
        local function link_bins()
            local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
            local target_bin = vim.fn.stdpath("data") .. "/bin"
            vim.fn.mkdir(target_bin, "p")
            for _, file in ipairs(vim.fn.glob(mason_bin .. "/*", 0, 1)) do
                local link = target_bin .. "/" .. vim.fn.fnamemodify(file, ":t")
                if vim.fn.filereadable(file) == 1 and vim.fn.filereadable(link) == 0 then
                    vim.fn.system({ "ln", "-s", file, link })
                end
            end
        end

        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            once = true,
            callback = function()
                vim.defer_fn(link_bins, 3000)
                local ok, mr = pcall(require, "mason-registry")
                if ok then
                    mr:on("package:install:success", function()
                        vim.schedule(link_bins)
                    end)
                end
            end,
        })
    end,
}
