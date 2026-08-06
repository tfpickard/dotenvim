-- BUG FIX: no trigger + `defaults = { lazy = true }` meant smartcolumn never
-- loaded, so no colorcolumn was ever shown.
return {
    "m4xshen/smartcolumn.nvim",
    event = "LazyFile",
    opts = {
        colorcolumn = "100",
        disabled_filetypes = { "help", "text", "markdown" },
        custom_colorcolumn = { c = "80" },
        scope = "file",
        editorconfig = true,
    },
}
