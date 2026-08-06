-- Bridge between Neovim and the system-wide theme switcher in ~/.config/themes.
--
-- `theme-set` (in the dotfiles repo) flips ~/.config/themes/active to point at
-- a theme directory and pokes every app to reload. Each theme dir contains a
-- palette.json with a fixed schema, which this module turns into a Neovim
-- colorscheme so nvim matches the rest of the desktop -- including bespoke
-- themes that have no upstream Neovim port.
--
-- Design notes:
--  * No plugin dependency and no generated files on disk. The palette is read
--    and highlights are set in-process, so switching is instant and there is
--    nothing to regenerate or keep in sync.
--  * Highlights are derived from the 14 required palette keys only. Every
--    theme in the repo defines all of them (verified), so any theme works
--    without special casing.
--  * LSP semantic groups are linked to base groups rather than coloured
--    individually; that keeps this small while still covering modern
--    highlighting.
local M = {}

local PALETTE = vim.fn.expand("~/.config/themes/active/palette.json")

---Blend two "#rrggbb" colours. alpha=0 returns base, alpha=1 returns target.
---@param base string
---@param target string
---@param alpha number
---@return string
function M.blend(base, target, alpha)
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

---Read and validate the active palette.
---@return table|nil palette, string|nil err
function M.palette()
    local f = io.open(PALETTE, "r")
    if not f then
        return nil, "no palette at " .. PALETTE
    end
    local raw = f:read("*a")
    f:close()

    local ok, data = pcall(vim.json.decode, raw)
    if not ok or type(data) ~= "table" then
        return nil, "palette is not valid JSON"
    end

    -- Every theme in the repo defines all of these; bail out rather than
    -- render a half-themed editor if one is missing.
    local required = {
        "bg", "bg_dark", "surface", "overlay", "text", "subtext",
        "accent", "accent2", "blue", "green", "yellow", "orange", "red", "pink",
    }
    for _, key in ipairs(required) do
        if type(data[key]) ~= "string" then
            return nil, "palette is missing key: " .. key
        end
    end
    return data
end

---Build the highlight table for a palette.
---@param p table
---@return table<string, table>
local function highlights(p)
    -- Derived shades. The palette gives a base ramp; these fill the gaps so
    -- diffs, folds and selections read correctly on any theme.
    local sel = M.blend(p.bg, p.accent, 0.22)
    local line = M.blend(p.bg, p.text, 0.07) -- cursor crosshair (see options.lua)
    local col = M.blend(p.bg, p.text, 0.045)
    local dim = M.blend(p.bg, p.text, 0.14)
    local diff_add = M.blend(p.bg, p.green, 0.20)
    local diff_del = M.blend(p.bg, p.red, 0.20)
    local diff_chg = M.blend(p.bg, p.blue, 0.18)
    local diff_txt = M.blend(p.bg, p.blue, 0.34)

    return {
        -- Editor chrome
        Normal = { fg = p.text, bg = p.bg },
        NormalNC = { fg = p.text, bg = p.bg },
        NormalFloat = { fg = p.text, bg = p.bg_dark },
        FloatBorder = { fg = p.overlay, bg = p.bg_dark },
        FloatTitle = { fg = p.accent, bg = p.bg_dark, bold = true },
        ColorColumn = { bg = p.surface },
        Conceal = { fg = p.overlay },
        Cursor = { fg = p.bg, bg = p.text },
        lCursor = { fg = p.bg, bg = p.text },
        CursorIM = { fg = p.bg, bg = p.text },
        CursorLine = { bg = line },
        CursorColumn = { bg = col },
        CursorLineNr = { fg = p.accent, bold = true },
        LineNr = { fg = p.overlay },
        LineNrAbove = { fg = p.overlay },
        LineNrBelow = { fg = p.overlay },
        SignColumn = { bg = p.bg },
        FoldColumn = { fg = p.overlay, bg = p.bg },
        Folded = { fg = p.subtext, bg = p.surface },
        VertSplit = { fg = p.surface },
        WinSeparator = { fg = p.surface },
        EndOfBuffer = { fg = p.bg },
        NonText = { fg = dim },
        SpecialKey = { fg = p.overlay },
        Whitespace = { fg = dim },
        MatchParen = { fg = p.orange, bold = true },
        Directory = { fg = p.blue },
        Title = { fg = p.accent, bold = true },
        Question = { fg = p.green },
        MoreMsg = { fg = p.green },
        ModeMsg = { fg = p.text, bold = true },
        ErrorMsg = { fg = p.red },
        WarningMsg = { fg = p.orange },
        WinBar = { fg = p.subtext, bg = p.bg },
        WinBarNC = { fg = p.overlay, bg = p.bg },

        -- Selection / search
        Visual = { bg = sel },
        VisualNOS = { bg = sel },
        Search = { fg = p.bg, bg = p.yellow },
        IncSearch = { fg = p.bg, bg = p.orange },
        CurSearch = { fg = p.bg, bg = p.orange },
        Substitute = { fg = p.bg, bg = p.red },

        -- Statusline / tabline
        StatusLine = { fg = p.subtext, bg = p.surface },
        StatusLineNC = { fg = p.overlay, bg = p.bg_dark },
        TabLine = { fg = p.overlay, bg = p.bg_dark },
        TabLineFill = { bg = p.bg_dark },
        TabLineSel = { fg = p.bg, bg = p.accent },

        -- Popup menu
        Pmenu = { fg = p.subtext, bg = p.bg_dark },
        PmenuSel = { fg = p.text, bg = sel, bold = true },
        PmenuSbar = { bg = p.surface },
        PmenuThumb = { bg = p.overlay },
        PmenuMatch = { fg = p.accent, bold = true },
        PmenuMatchSel = { fg = p.accent, bg = sel, bold = true },
        WildMenu = { fg = p.bg, bg = p.accent },

        -- Diff
        DiffAdd = { bg = diff_add },
        DiffDelete = { bg = diff_del },
        DiffChange = { bg = diff_chg },
        DiffText = { bg = diff_txt },
        Added = { fg = p.green },
        Removed = { fg = p.red },
        Changed = { fg = p.blue },

        -- Spell
        SpellBad = { sp = p.red, undercurl = true },
        SpellCap = { sp = p.yellow, undercurl = true },
        SpellLocal = { sp = p.blue, undercurl = true },
        SpellRare = { sp = p.pink, undercurl = true },

        -- Syntax
        Comment = { fg = p.overlay, italic = true },
        Constant = { fg = p.orange },
        String = { fg = p.green },
        Character = { fg = p.green },
        Number = { fg = p.orange },
        Boolean = { fg = p.orange },
        Float = { fg = p.orange },
        Identifier = { fg = p.text },
        Function = { fg = p.blue },
        Statement = { fg = p.accent },
        Conditional = { fg = p.accent },
        Repeat = { fg = p.accent },
        Label = { fg = p.accent },
        Operator = { fg = p.accent2 },
        Keyword = { fg = p.accent },
        Exception = { fg = p.accent },
        PreProc = { fg = p.pink },
        Include = { fg = p.pink },
        Define = { fg = p.pink },
        Macro = { fg = p.pink },
        PreCondit = { fg = p.pink },
        Type = { fg = p.yellow },
        StorageClass = { fg = p.yellow },
        Structure = { fg = p.yellow },
        Typedef = { fg = p.yellow },
        Special = { fg = p.accent2 },
        SpecialChar = { fg = p.accent2 },
        Tag = { fg = p.accent2 },
        Delimiter = { fg = p.subtext },
        SpecialComment = { fg = p.overlay, italic = true },
        Debug = { fg = p.red },
        Underlined = { underline = true },
        Bold = { bold = true },
        Italic = { italic = true },
        Error = { fg = p.red },
        Todo = { fg = p.bg, bg = p.yellow, bold = true },

        -- Diagnostics
        DiagnosticError = { fg = p.red },
        DiagnosticWarn = { fg = p.orange },
        DiagnosticInfo = { fg = p.blue },
        DiagnosticHint = { fg = p.accent2 },
        DiagnosticOk = { fg = p.green },
        DiagnosticUnderlineError = { sp = p.red, undercurl = true },
        DiagnosticUnderlineWarn = { sp = p.orange, undercurl = true },
        DiagnosticUnderlineInfo = { sp = p.blue, undercurl = true },
        DiagnosticUnderlineHint = { sp = p.accent2, undercurl = true },
        DiagnosticVirtualTextError = { fg = p.red, bg = M.blend(p.bg, p.red, 0.10) },
        DiagnosticVirtualTextWarn = { fg = p.orange, bg = M.blend(p.bg, p.orange, 0.10) },
        DiagnosticVirtualTextInfo = { fg = p.blue, bg = M.blend(p.bg, p.blue, 0.10) },
        DiagnosticVirtualTextHint = { fg = p.accent2, bg = M.blend(p.bg, p.accent2, 0.10) },

        -- LSP
        LspReferenceText = { bg = p.surface },
        LspReferenceRead = { bg = p.surface },
        LspReferenceWrite = { bg = p.surface, underline = true },
        LspInlayHint = { fg = p.overlay, bg = M.blend(p.bg, p.overlay, 0.12) },
        LspSignatureActiveParameter = { fg = p.orange, bold = true },
        LspCodeLens = { fg = p.overlay, italic = true },

        -- Treesitter (only where a link would be wrong)
        ["@variable"] = { fg = p.text },
        ["@variable.builtin"] = { fg = p.red },
        ["@variable.parameter"] = { fg = p.subtext, italic = true },
        ["@variable.member"] = { fg = p.accent2 },
        ["@property"] = { fg = p.accent2 },
        ["@field"] = { fg = p.accent2 },
        ["@constant.builtin"] = { fg = p.orange, italic = true },
        ["@function.builtin"] = { fg = p.blue, italic = true },
        ["@constructor"] = { fg = p.yellow },
        ["@namespace"] = { fg = p.yellow },
        ["@module"] = { fg = p.yellow },
        ["@type.builtin"] = { fg = p.yellow, italic = true },
        ["@punctuation.bracket"] = { fg = p.subtext },
        ["@punctuation.delimiter"] = { fg = p.subtext },
        ["@punctuation.special"] = { fg = p.accent2 },
        ["@string.escape"] = { fg = p.accent2 },
        ["@string.regexp"] = { fg = p.accent2 },
        ["@tag"] = { fg = p.accent },
        ["@tag.attribute"] = { fg = p.yellow },
        ["@tag.delimiter"] = { fg = p.subtext },
        ["@markup.heading"] = { fg = p.accent, bold = true },
        ["@markup.link"] = { fg = p.blue, underline = true },
        ["@markup.link.url"] = { fg = p.blue, underline = true },
        ["@markup.raw"] = { fg = p.green },
        ["@markup.list"] = { fg = p.accent2 },
        ["@markup.strong"] = { bold = true },
        ["@markup.italic"] = { italic = true },
        ["@markup.strikethrough"] = { strikethrough = true },
        ["@comment.error"] = { fg = p.bg, bg = p.red, bold = true },
        ["@comment.warning"] = { fg = p.bg, bg = p.orange, bold = true },
        ["@comment.todo"] = { fg = p.bg, bg = p.yellow, bold = true },
        ["@comment.note"] = { fg = p.bg, bg = p.accent2, bold = true },
        ["@diff.plus"] = { fg = p.green },
        ["@diff.minus"] = { fg = p.red },

        -- Plugins used in this config
        SnacksIndent = { fg = M.blend(p.bg, p.text, 0.16) },
        SnacksIndentScope = { fg = p.accent },
        SnacksIndentChunk = { fg = p.accent },
        SnacksPickerMatch = { fg = p.accent, bold = true },
        SnacksNotifierInfo = { fg = p.blue },
        SnacksNotifierWarn = { fg = p.orange },
        SnacksNotifierError = { fg = p.red },
        BlinkCmpMenu = { fg = p.subtext, bg = p.bg_dark },
        BlinkCmpMenuBorder = { fg = p.overlay, bg = p.bg_dark },
        BlinkCmpMenuSelection = { bg = sel, bold = true },
        BlinkCmpLabelMatch = { fg = p.accent, bold = true },
        BlinkCmpKind = { fg = p.accent2 },
        BlinkCmpGhostText = { fg = p.overlay, italic = true },
        WhichKey = { fg = p.accent },
        WhichKeyGroup = { fg = p.blue },
        WhichKeyDesc = { fg = p.text },
        WhichKeySeparator = { fg = p.overlay },
        WhichKeyFloat = { bg = p.bg_dark },
        GitSignsAdd = { fg = p.green },
        GitSignsChange = { fg = p.blue },
        GitSignsDelete = { fg = p.red },
        TreesitterContext = { bg = p.surface },
        TreesitterContextLineNumber = { fg = p.overlay, bg = p.surface },
        IlluminatedWordText = { bg = p.surface },
        IlluminatedWordRead = { bg = p.surface },
        IlluminatedWordWrite = { bg = p.surface, underline = true },
    }
end

---Groups that are just aliases of another group.
local links = {
    ["@lsp.type.class"] = "Structure",
    ["@lsp.type.decorator"] = "Function",
    ["@lsp.type.enum"] = "Type",
    ["@lsp.type.enumMember"] = "Constant",
    ["@lsp.type.function"] = "Function",
    ["@lsp.type.interface"] = "Type",
    ["@lsp.type.macro"] = "Macro",
    ["@lsp.type.method"] = "Function",
    ["@lsp.type.namespace"] = "@namespace",
    ["@lsp.type.parameter"] = "@variable.parameter",
    ["@lsp.type.property"] = "@property",
    ["@lsp.type.struct"] = "Structure",
    ["@lsp.type.type"] = "Type",
    ["@lsp.type.typeParameter"] = "Type",
    ["@lsp.type.variable"] = "@variable",
    ["@function.call"] = "Function",
    ["@method"] = "Function",
    ["@method.call"] = "Function",
    ["@type.definition"] = "Typedef",
    ["@keyword.return"] = "Keyword",
    ["@keyword.function"] = "Keyword",
    ["@keyword.operator"] = "Operator",
    ["@keyword.import"] = "Include",
    NeoTreeNormal = "Normal",
    NeoTreeNormalNC = "NormalNC",
    TelescopeNormal = "NormalFloat",
    TelescopeBorder = "FloatBorder",
}

---Apply the active system palette as the current colorscheme.
---@param opts? { notify?: boolean }
---@return boolean applied
function M.apply(opts)
    opts = opts or {}
    local p, err = M.palette()
    if not p then
        if opts.notify then
            vim.notify(
                "System theme unavailable: " .. tostring(err),
                vim.log.levels.WARN,
                { title = "theme" }
            )
        end
        return false
    end

    -- Reset first so no stale groups survive from the previous theme.
    vim.cmd("highlight clear")
    if vim.fn.exists("syntax_on") == 1 then
        vim.cmd("syntax reset")
    end
    vim.o.termguicolors = true
    vim.o.background = "dark"
    vim.g.colors_name = "doots-" .. (p.name or "system")

    for group, spec in pairs(highlights(p)) do
        vim.api.nvim_set_hl(0, group, spec)
    end
    for group, target in pairs(links) do
        vim.api.nvim_set_hl(0, group, { link = target })
    end

    -- Let plugins that hook ColorScheme (lualine, snacks, ...) resync.
    vim.api.nvim_exec_autocmds("ColorScheme", { pattern = vim.g.colors_name, modeline = false })

    if opts.notify then
        vim.notify("Theme: " .. (p.name or "system"), vim.log.levels.INFO, { title = "theme" })
    end
    return true
end

---Re-read the palette and reapply. Called by `theme-set` over the socket of
---every running nvim, so open editors follow a system theme switch live.
function M.reload()
    if not M.apply({ notify = true }) then
        vim.cmd.colorscheme("tokyonight")
    end
end

return M
