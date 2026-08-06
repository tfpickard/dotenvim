-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
-- NOTE: format-on-save is handled by LazyVim (vim.g.autoformat + conform.nvim).
-- Don't add a manual BufWritePre conform autocmd here: it would bypass the
-- <leader>uf / <leader>uF toggles and vim.b.autoformat.

-- ── Subtle "cartesian" cursor crosshair (generic fallback) ───────────────────
-- Keep BOTH cursorline and cursorcolumn (set in options.lua) but tone them down
-- to a faint tint so the crosshair reads as a gentle, semi-transparent guide
-- instead of two solid bars. Recomputed on every ColorScheme so it survives
-- theme switches.
-- NOTE: the default theme (tokyonight) applies this via its own `on_highlights`
-- hook in lua/plugins/colorscheme.lua, which wins the startup race cleanly.
-- This autocmd is the fallback that covers any *other* colorscheme you switch to.
local function blend_channel(base, target, alpha)
    return math.floor(base + (target - base) * alpha + 0.5)
end

local function blend_hex(base, target, alpha)
    local function split(c)
        return math.floor(c / 65536) % 256, math.floor(c / 256) % 256, c % 256
    end
    local br, bg, bb = split(base)
    local tr, tg, tb = split(target)
    return string.format(
        "#%02x%02x%02x",
        blend_channel(br, tr, alpha),
        blend_channel(bg, tg, alpha),
        blend_channel(bb, tb, alpha)
    )
end

local function subtle_cursor_crosshair()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
    local bg, fg = normal.bg, normal.fg
    if not bg or not fg then
        return
    end
    -- Faint: line a touch stronger than the column so their intersection still
    -- reads. Bump these alphas up if you want the crosshair more visible.
    local line_bg = blend_hex(bg, fg, 0.07)
    local col_bg = blend_hex(bg, fg, 0.045)
    vim.api.nvim_set_hl(0, "CursorLine", { bg = line_bg })
    vim.api.nvim_set_hl(0, "CursorColumn", { bg = col_bg })
end

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("subtle_cursor_crosshair", { clear = true }),
    callback = function()
        -- Defer to the end of the tick so we run *after* the colorscheme's own
        -- (synchronous) CursorLine/CursorColumn highlight setup, otherwise the
        -- theme clobbers our subtle tint.
        vim.schedule(subtle_cursor_crosshair)
    end,
})
-- Apply once, shortly after startup settles, so we win the startup race with
-- the colorscheme's own highlight setup.
vim.defer_fn(subtle_cursor_crosshair, 200)
