-- Make format-on-save respect the indentation conventions already present in
-- each file (or the project's own formatter config) instead of forcing the
-- global 4-space default from options.lua onto every repo.
return {
    -- Detect indentation (width + tabs vs spaces) from buffer content and set
    -- buffer-local shiftwidth/expandtab accordingly. Formatters that read
    -- buffer options (shfmt, LSP fallback formatting, and the conform
    -- overrides below) will then preserve the file's existing style.
    -- Respects .editorconfig (won't override it) by default.
    {
        "nmac427/guess-indent.nvim",
        event = "LazyFile",
        opts = {},
    },

    {
        "stevearc/conform.nvim",
        optional = true,
        opts = function(_, opts)
            local function has_project_config(ctx, names)
                return vim.fs.find(names, { path = ctx.dirname, upward = true })[1] ~= nil
            end

            opts.formatters = opts.formatters or {}

            -- stylua defaults to 4-space indents when the project has no
            -- stylua.toml. Follow the buffer's detected indent instead.
            -- CLI args override stylua.toml, so skip this when the project
            -- defines its own config (conform already passes
            -- --search-parent-directories so that config gets picked up).
            opts.formatters.stylua = vim.tbl_deep_extend("force", opts.formatters.stylua or {}, {
                prepend_args = function(_, ctx)
                    if has_project_config(ctx, { ".stylua.toml", "stylua.toml", ".editorconfig" }) then
                        return {}
                    end
                    if vim.bo[ctx.buf].expandtab then
                        return { "--indent-type", "Spaces", "--indent-width", tostring(ctx.shiftwidth) }
                    end
                    return { "--indent-type", "Tabs" }
                end,
            })

            -- prettier defaults to 2-space indents. Follow the buffer's
            -- detected indent unless the project has a prettier config or
            -- .editorconfig (prettier reads both on its own, and CLI args
            -- would override them).
            local prettier_configs = {
                ".prettierrc",
                ".prettierrc.json",
                ".prettierrc.yml",
                ".prettierrc.yaml",
                ".prettierrc.json5",
                ".prettierrc.js",
                ".prettierrc.cjs",
                ".prettierrc.mjs",
                ".prettierrc.toml",
                "prettier.config.js",
                "prettier.config.cjs",
                "prettier.config.mjs",
                ".editorconfig",
            }
            opts.formatters.prettier = vim.tbl_deep_extend("force", opts.formatters.prettier or {}, {
                prepend_args = function(_, ctx)
                    if has_project_config(ctx, prettier_configs) then
                        return {}
                    end
                    if vim.bo[ctx.buf].expandtab then
                        return { "--tab-width", tostring(ctx.shiftwidth) }
                    end
                    return { "--use-tabs" }
                end,
            })
        end,
    },
}
