-- Colorscheme.
--
-- ── System-wide theme integration (~/.config/themes) ─────────────────────────
-- The dotfiles repo ships a global theme switcher (`theme-set`) that flips the
-- symlink ~/.config/themes/active -> <theme>/ and pokes every app to reload.
-- Each theme dir carries a palette.json with a fixed schema:
--
--   name bg bg_dark surface overlay text subtext
--   accent accent2 blue green yellow orange red pink
--   [focus_gradient: {from,to,angle}]
--
-- Only one of the five themes (catppuccin-mocha) has a matching Neovim
-- colorscheme plugin, so *mapping* theme names onto plugins would leave the
-- other four (aura, cyberdream, dreamcore-pastel, sgi) unthemed. Instead
-- lua/util/theme.lua builds a colorscheme directly from the palette, so nvim
-- tracks the system theme exactly -- bespoke themes included -- with no
-- per-theme plugin and nothing to regenerate.
--
-- Falls back to tokyonight when the palette is unreadable (fresh checkout, a
-- machine without the dotfiles, or a dangling symlink), so nvim is never left
-- unthemed.
local theme = require("util.theme")

return {
    -- Fallback colorscheme, and the source of the crosshair tint when the
    -- system palette isn't available.
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            on_highlights = function(hl, c)
                -- Subtle "cartesian" cursor crosshair: keep BOTH cursorline
                -- and cursorcolumn (see options.lua) but tone them down to a
                -- faint tint, so they read as a gentle guide rather than two
                -- solid bars. Using the theme's own hook means it is reapplied
                -- on every load and can't be clobbered by a ColorScheme
                -- autocmd racing the theme at startup.
                hl.CursorLine = { bg = theme.blend(c.bg, c.fg, 0.07) }
                hl.CursorColumn = { bg = theme.blend(c.bg, c.fg, 0.045) }
            end,
        },
    },

    {
        "LazyVim/LazyVim",
        opts = {
            -- `colorscheme` may be a function, so the palette-vs-fallback
            -- decision happens at load time rather than spec-eval time.
            colorscheme = function()
                if not theme.apply() then
                    vim.cmd.colorscheme("tokyonight")
                end
            end,
        },
    },

    -- :Theme reloads from the active palette. `theme-set` calls this over the
    -- socket of every running nvim, so open editors follow a system theme
    -- switch live instead of needing a restart.
    {
        "folke/snacks.nvim",
        optional = true,
        init = function()
            vim.api.nvim_create_user_command("Theme", function()
                require("util.theme").reload()
            end, { desc = "Reload colours from the active system theme" })
        end,
    },
}
