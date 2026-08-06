-- Subtle "cartesian" cursor crosshair for tokyonight (the default theme).
--
-- We keep BOTH cursorline and cursorcolumn on (see options.lua) but tone them
-- down to a faint tint so the crosshair reads as a gentle, semi-transparent
-- guide rather than two solid bars. Doing this via tokyonight's own
-- `on_highlights` hook means the theme applies it on every load, so nothing
-- can clobber it (unlike a ColorScheme autocmd, which races the theme at
-- startup). The generic autocmd in config/autocmds.lua covers other themes.
local function blend(base, target, alpha)
    local function ch(hex, i)
        return tonumber(hex:sub(i, i + 1), 16)
    end
    local function mix(a, b)
        return math.floor(a + (b - a) * alpha + 0.5)
    end
    return string.format(
        "#%02x%02x%02x",
        mix(ch(base, 2), ch(target, 2)),
        mix(ch(base, 4), ch(target, 4)),
        mix(ch(base, 6), ch(target, 6))
    )
end

return {
    "folke/tokyonight.nvim",
    opts = {
        on_highlights = function(hl, c)
            -- line a touch stronger than the column so their intersection
            -- still reads. Bump these alphas up for a more visible crosshair.
            hl.CursorLine = { bg = blend(c.bg, c.fg, 0.07) }
            hl.CursorColumn = { bg = blend(c.bg, c.fg, 0.045) }
        end,
    },
}
