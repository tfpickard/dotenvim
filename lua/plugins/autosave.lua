return {
    "tmillr/sos.nvim",
    config = function()
        require("sos").setup({
            ---Whether to enable the plugin.
            enabled = true,

            ---Timeout in milliseconds for the global timer. Buffer changes debounce the
            ---timer.
            timeout = 10000,

            ---Automatically create missing parent directories when writing/autosaving a
            ---buffer.
            create_parent_dirs = true,

            ---Whether to set and manage Vim's 'autowrite' option.
            ---
            ---### Choices:
            ---
            ---  - "all": set and manage 'autowriteall'
            ---  - true : set and manage 'autowrite'
            ---  - false: don't set or manage any of Vim's 'autowwrite' options
            autowrite = false,

            ---Save all buffers before executing a `:` command on the cmdline (does not
            ---include `<Cmd>` mappings).
            ---
            ---### Choices:
            ---
            ---  - "all"                 : save on any cmd that gets executed
            ---  - "some"                : only for some commands (source, luafile, etc.).
            ---                            not perfect, but may lead to fewer unnecessary
            ---                            file writes compared to `"all"`.
            ---  - table<string, boolean>: map specifying which commands trigger a save
            ---                            where keys are the full command names
            ---  - false                 : never/disable
            save_on_cmd = "some",

            ---Save current buffer on `BufLeave`. See `:help BufLeave`.
            save_on_bufleave = true,

            ---Save all buffers when Neovim loses focus or is suspended.
            save_on_focuslost = true,

            should_save = {
                ---Whether to autosave buffers which aren't modifiable.
                ---See `:help 'modifiable'`.
                unmodifiable = true,

                ---How to handle `acwrite` type buffers (i.e. where `vim.bo.buftype ==
                ---"acwrite"` or the buffer's name is a URI). These buffers use an autocmd to
                ---perform special actions and side-effects when saved/written.
                acwrite = {
                    ---Whether to autosave buffers which perform network actions (such as sending a
                    ---request) on save/write. E.g. `scp`, `http`
                    net = true,

                    ---Whether to autosave buffers which perform git actions (such as staging
                    ---buffer content) on save/write. E.g. `fugitive`, `diffview`, `gitsigns`
                    git = true,

                    ---Whether to autosave buffers which process the file on save/write.
                    ---E.g. `tar`, `zip`, `gzip`
                    compress = true,

                    ---Whether to autosave `acwrite` buffers which don't match any of the other
                    ---acwrite criteria/filters.
                    other = true,

                    ---URI schemes to allow/disallow autosaving for. If a scheme is set to `false`,
                    ---any buffer whose name begins with that scheme will not be autosaved.
                    ---Provided schemes should be lowercase and will be matched case-insensitively.
                    ---Schemes take precedence over other `acwrite` filters.
                    ---
                    ---Example:
                    ---
                    ---```lua
                    ---schemes = { http = false, octo = false, file = true }
                    ---```
                    schemes = {
                        ---Octo buffers are disabled by default as they can create new
                        ---issues, PR's, and comments on write/save.
                        octo = false,
                        term = false,
                        file = true,
                    },
                },
            },

            hooks = {
                ---A function – or any other callable value – which is called just before
                ---writing/autosaving a buffer. If `false` is returned, the buffer will not be
                ---written.
                buf_autosave_pre = function(bufnr, bufname) end,

                ---A function – or any other callable value – which is called just after
                ---writing/autosaving a buffer (even if the write failed).
                buf_autosave_post = function(bufnr, bufname, errmsg) end,
            },
        })
    end,
}
