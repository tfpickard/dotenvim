-- Autosave.
--
-- Replaces tmillr/sos.nvim, which went stale (last push 2024-12, 22 stars) and
-- was the least-maintained plugin in this config. okuuva/auto-save.nvim is the
-- actively-developed successor to the popular Pocco81/auto-save.nvim and keeps
-- the same debounced-write behaviour we had configured.
--
-- Full default surface is listed inline so the available knobs are visible.
return {
    "okuuva/auto-save.nvim",
    version = "^1", -- pin to the v1 API
    cmd = "ASToggle", -- :ASToggle turns autosaving on/off
    event = { "InsertLeave", "TextChanged" },
    keys = {
        { "<leader>uW", "<cmd>ASToggle<cr>", desc = "Toggle Autosave" },
    },
    opts = {
        enabled = true, -- start enabled; :ASToggle flips it

        -- Events that *queue* a save. BufLeave/FocusLost reproduce sos.nvim's
        -- save_on_bufleave / save_on_focuslost.
        trigger_events = {
            immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" },
            defer_save = { "InsertLeave", "TextChanged" },
            cancel_deferred_save = { "InsertEnter" },
        },

        -- Debounce before a deferred write, in ms. sos.nvim used 10000.
        debounce_delay = 5000,

        -- Only write buffers that are worth writing. Returning false skips.
        condition = function(buf)
            -- Never autosave special buffers (terminals, oil://, fugitive, ...)
            if vim.bo[buf].buftype ~= "" then
                return false
            end
            -- Skip unnamed and unmodifiable buffers
            if vim.api.nvim_buf_get_name(buf) == "" or not vim.bo[buf].modifiable then
                return false
            end
            -- Respect a per-buffer opt-out: :lua vim.b.auto_save = false
            if vim.b[buf].auto_save == false then
                return false
            end
            return true
        end,

        write_all_buffers = false, -- only the current buffer, not every buffer
        noautocmd = false, -- keep BufWritePre/Post firing (format-on-save!)
        lockmarks = false, -- pass `lockmarks` to the write command
        debug = false, -- log to auto-save.log in stdpath("log")
    },
}
