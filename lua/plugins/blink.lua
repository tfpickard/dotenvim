-- blink.cmp customisations.
--
-- The base config comes from `lazyvim.plugins.extras.coding.blink`, which is
-- enabled in lazyvim.json. This file previously carried a 238-line verbatim
-- fork of that extra, which had drifted from upstream and was:
--   * calling the removed `require("blink.cmp.keymap.presets")["super-tab"]`
--     table-index API instead of the current `.get("super-tab")` function
--   * missing `ai_nes` in the <Tab> chain, so Copilot Next Edit Suggestions
--     were never surfaced
--   * pinning `snippets.expand` unconditionally and using the old
--     `auto_show()` (no ctx) signature
-- Everything else in it (appearance, completion, cmdline, keymap preset) was
-- byte-identical to the extra, so only the genuine delta is kept here.
return {
    "saghen/blink.cmp",
    dependencies = {
        { "mikavilpas/blink-ripgrep.nvim", version = "*" },
    },
    opts = {
        sources = {
            -- opts_extend in the LazyVim extra appends to the default list
            -- ({ "lsp", "path", "snippets", "buffer" }) rather than replacing it.
            default = { "ripgrep" },
            providers = {
                ripgrep = {
                    module = "blink-ripgrep",
                    name = "Ripgrep",
                    ---@module "blink-ripgrep"
                    ---@type blink-ripgrep.Options
                    opts = {
                        prefix_min_len = 4,
                        project_root_marker = { ".git", "package.json", "pyproject.toml" },
                        fallback_to_regex_highlighting = true,
                        backend = {
                            use = "gitgrep-or-ripgrep",
                            ripgrep = {
                                max_filesize = "1M",
                                search_casing = "--smart-case",
                            },
                        },
                    },
                },
            },
        },
    },
}
