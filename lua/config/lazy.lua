local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        -- add LazyVim and import its plugins
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        -- import/override with your plugins
        { import = "plugins" },
        { import = "plugins.lang" },
        { import = "plugins.ui" },
    },
    defaults = {
        -- Make custom specs opt-in for eager loading; tighten startup surface.
        lazy = true,
        -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
        -- have outdated releases, which may break your Neovim install.
        version = false, -- always use the latest git commit
        -- version = "*", -- try installing the latest stable version for plugins that support semver
    },
    install = { colorscheme = { "tokyonight", "habamax" } },
    checker = {
        enabled = true, -- check for plugin updates periodically
        notify = false, -- don't pop up on every update
        frequency = 86400, -- once a day instead of every 3600s (default),
        -- so startup isn't racing a git fetch for 77 plugins
    },
    change_detection = {
        enabled = true,
        notify = false, -- stop the "config changed" toast on every edit
    },
    performance = {
        rtp = {
            -- disable some rtp plugins
            -- matchit/matchparen are left ENABLED on purpose: disabling them
            -- breaks % motion and bracket highlighting. netrw stays enabled
            -- because plugins still shell out to it for `gx`-style opens.
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
                "rplugin", -- no remote (python/node) plugins in this config
                -- NOT disabled: "editorconfig". formatting.lua and
                -- smartcolumn both treat .editorconfig as authoritative.
            },
        },
    },
})
