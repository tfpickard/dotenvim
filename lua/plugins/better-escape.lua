-- jk / jj to escape, without the input lag of an `imap jk <Esc>`.
--
-- BUG FIX: this spec had no `event`/`keys`/`cmd`, and lua/config/lazy.lua sets
-- `defaults = { lazy = true }`. A lazy plugin with no trigger is never loaded
-- by lazy.nvim, so better-escape was silently dead -- `jk` in insert mode did
-- nothing at all. VeryLazy is the right trigger here because the mappings span
-- insert, cmdline, terminal, visual and select modes, so waiting for
-- InsertEnter would leave the other four modes unmapped.
return {
    "max397574/better-escape.nvim",
    event = "VeryLazy",
    opts = {
        timeout = vim.o.timeoutlen, -- ms to wait for the second key
        default_mappings = true, -- keep the plugin's own defaults too
        mappings = {
            i = { j = { k = "<Esc>", j = "<Esc>" } }, -- insert
            c = { j = { k = "<C-c>", j = "<C-c>" } }, -- cmdline
            t = { j = { k = "<C-\\><C-n>" } }, -- terminal
            v = { j = { k = "<Esc>" } }, -- visual
            s = { j = { k = "<Esc>" } }, -- select
        },
    },
}
