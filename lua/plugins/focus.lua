-- Auto-resize the focused split.
--
-- IMPORTANT: this config also enables the `ui.edgy` extra, and edgy owns the
-- geometry of sidebar/panel windows (neo-tree, trouble, terminals, help, ...).
-- Left unconstrained, focus.nvim fights edgy for those windows and they visibly
-- jitter as you move between splits. The exclusion lists below hand all
-- edgy-managed and transient windows back to edgy, so focus.nvim only resizes
-- ordinary file splits.
--
-- Note: focus.nvim's own cursorline/cursorcolumn handling is left OFF so it
-- doesn't clobber the subtle crosshair tint set in plugins/colorscheme.lua.
return {
    "nvim-focus/focus.nvim",
    version = false,
    event = "VeryLazy",
    opts = {
        enable = true, -- master switch
        commands = true, -- create :Focus… commands

        autoresize = {
            enable = true, -- resize splits as focus changes
            width = 0, -- force width of focused window (0 = golden ratio)
            height = 0, -- force height of focused window
            minwidth = 0, -- minimum width of unfocused windows
            minheight = 0, -- minimum height of unfocused windows
            focusedwindow_minwidth = 0,
            focusedwindow_minheight = 0,
            height_quickfix = 10, -- fixed height for the quickfix panel
        },

        split = {
            bufnew = false, -- don't open a blank buffer in new splits
            tmux = false, -- don't create tmux splits instead of nvim ones
        },

        ui = {
            number = false, -- line numbers only in the focused window
            relativenumber = false,
            hybridnumber = false,
            absolutenumber_unfocussed = false,
            -- Left false: options.lua + colorscheme.lua own the crosshair.
            cursorline = false,
            cursorcolumn = false,
            colorcolumn = { enable = false, list = "+1" },
            signcolumn = true,
            winhighlight = false,
        },
    },
    config = function(_, opts)
        require("focus").setup(opts)

        -- Hand edgy-managed and transient windows back to edgy.
        local ignore_filetypes = {
            "neo-tree", "snacks_layout_box", "snacks_picker_list", "snacks_terminal",
            "trouble", "qf", "help", "man", "aerial", "Outline", "toggleterm",
            "lazy", "mason", "oil", "DiffviewFiles", "DiffviewFileHistory",
            "edgy", "noice", "notify", "TelescopePrompt", "codecompanion",
        }
        local ignore_buftypes = { "nofile", "prompt", "popup", "terminal", "quickfix" }

        local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })
        vim.api.nvim_create_autocmd("WinEnter", {
            group = augroup,
            desc = "Disable focus autoresize for excluded buftypes",
            callback = function()
                vim.w.focus_disable = vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
            end,
        })
        vim.api.nvim_create_autocmd("FileType", {
            group = augroup,
            desc = "Disable focus autoresize for excluded filetypes",
            callback = function()
                vim.b.focus_disable = vim.tbl_contains(ignore_filetypes, vim.bo.filetype)
            end,
        })
    end,
}
