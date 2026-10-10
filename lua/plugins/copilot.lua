-- Copilot. The base spec comes from `lazyvim.plugins.extras.ai.copilot`
-- (enabled in lazyvim.json); this file only carries local preferences.
--
-- With vim.g.ai_cmp = true (options.lua), Copilot completions are surfaced
-- through blink.cmp and accepted with <Tab>, so no inline <C-j>/<C-k> maps are
-- defined here -- they'd be dead *and* would collide with the <C-j>/<C-k>
-- window-navigation maps. Set vim.g.ai_cmp = false to get inline ghost text
-- back, at which point <M-]> / <M-[> cycle suggestions.
--
-- Removed from this spec: `vim.g.copilot_enabled` and `vim.g.copilot_no_tab_map`.
-- Those are options of the *vimscript* plugin github/copilot.vim; copilot.lua
-- never reads them (verified: 0 references in its source), so they were no-ops.
return {
    "zbirenbaum/copilot.lua",
    opts = {
        -- Inherited defaults from the LazyVim extra, shown for visibility:
        --   suggestion = {
        --     enabled       = not vim.g.ai_cmp,   -- inline ghost text
        --     auto_trigger  = true,
        --     hide_during_completion = vim.g.ai_cmp,
        --     keymap = { accept = false, next = "<M-]>", prev = "<M-[>" },
        --   }
        --   panel    = { enabled = false }
        --   filetypes = { markdown = true, help = true }

        -- Don't offer completions where they're noise or a privacy risk.
        filetypes = {
            gitcommit = false,
            gitrebase = false,
            hgcommit = false,
            svn = false,
            cvs = false,
            ["."] = false, -- dotfiles-with-no-extension (e.g. .env)
        },
    },
}
