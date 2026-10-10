-- Options are automatically loaded before lazy.nvim startup.
--
-- ── How to read this file ───────────────────────────────────────────────────
-- ACTIVE section  = settings that differ from LazyVim and are really applied.
-- REFERENCE block = LazyVim's defaults, listed (commented) so you can see the
--                   full surface of what's available and what it's set to.
--                   Uncomment a line only if you want to *change* its value.
--
-- Why the reference block is commented rather than live: this file used to
-- re-assign 46 of these verbatim, which meant any upstream fix was silently
-- overridden by a stale copy. Three had already rotted into *broken* state --
-- `formatexpr`/`foldtext` still pointed at `v:lua.require'lazyvim.util'...`,
-- an API LazyVim removed, so gq-formatting and foldtext were dead. Keeping
-- them commented gives the same at-a-glance overview with none of the risk.
-- Upstream: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │ ACTIVE — LazyVim globals                                                 │
-- ╰──────────────────────────────────────────────────────────────────────────╯
vim.g.autoformat = true -- format on save (toggle: <leader>uf / <leader>uF)
vim.g.snacks_animate = true -- master switch for all snacks animations
vim.g.lazyvim_picker = "auto" -- "auto" | "telescope" | "fzf" | "snacks"
vim.g.lazyvim_cmp = "auto" -- "auto" | "nvim-cmp" | "blink.cmp"
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
vim.g.root_lsp_ignore = { "copilot" } -- don't let copilot's LSP define the root
vim.g.trouble_lualine = true -- show document symbols in lualine

-- Surface Copilot through blink.cmp (accept with <Tab>) instead of inline
-- ghost text. Set false to get inline suggestions back. See plugins/copilot.lua.
vim.g.ai_cmp = true

vim.g.markdown_recommended_style = 0 -- don't force 2-space indent in markdown

local opt = vim.opt

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │ ACTIVE — overrides of LazyVim defaults                                   │
-- ╰──────────────────────────────────────────────────────────────────────────╯
opt.shiftwidth = 4 -- LazyVim default: 2
opt.tabstop = 4 -- LazyVim default: 2
-- guess-indent.nvim overrides both per-buffer when a file/project clearly
-- uses a different style, so these are just the fallback.

opt.cursorcolumn = true -- not set by LazyVim; the vertical half of the
-- cursor crosshair. plugins/colorscheme.lua tints
-- CursorLine/CursorColumn so it reads as a faint
-- guide rather than two solid bars.

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │ REFERENCE — LazyVim defaults (already applied; shown for discoverability) │
-- ╰──────────────────────────────────────────────────────────────────────────╯
-- opt.autowrite     = true                  -- auto write on buffer switch
-- opt.clipboard     = vim.env.SSH_CONNECTION and "" or "unnamedplus"
--                                           -- empty over SSH so OSC-52 works
-- opt.completeopt   = "menu,menuone,noselect"
-- opt.conceallevel  = 2                     -- hide markdown markup
-- opt.confirm       = true                  -- ask instead of failing on :q
-- opt.cursorline    = true                  -- highlight current line
-- opt.expandtab     = true                  -- spaces, not tabs
-- opt.fillchars     = { foldopen = "", foldclose = "", fold = " ",
--                       foldsep = " ", diff = "╱", eob = " " }
-- opt.foldlevel     = 99                    -- start with everything unfolded
-- opt.foldtext      = ""                    -- use treesitter/`foldexpr` text
-- opt.formatexpr    = "v:lua.LazyVim.format.formatexpr()"
-- opt.formatoptions = "jcroqlnt"
-- opt.grepformat    = "%f:%l:%c:%m"
-- opt.grepprg       = "rg --vimgrep"
-- opt.ignorecase    = true
-- opt.inccommand    = "nosplit"             -- live :s preview
-- opt.jumpoptions   = "view"
-- opt.laststatus    = 3                     -- single global statusline
-- opt.linebreak     = true                  -- wrap at word boundaries
-- opt.list          = true                  -- show invisible chars
-- opt.mouse         = "a"
-- opt.number        = true
-- opt.pumblend      = 10                    -- popup transparency
-- opt.pumheight     = 10                    -- max popup entries
-- opt.relativenumber= true
-- opt.ruler         = false
-- opt.scrolloff     = 4                     -- vertical context lines
-- opt.sessionoptions= { "buffers", "curdir", "tabpages", "winsize", "help",
--                       "globals", "skiprtp", "folds" }
-- opt.shiftround    = true
-- opt.shortmess:append({ W = true, I = true, c = true, C = true })
-- opt.showmode      = false                 -- statusline already shows it
-- opt.sidescrolloff = 8                     -- horizontal context columns
-- opt.signcolumn    = "yes"                 -- always on, avoids text shifting
-- opt.smartcase     = true
-- opt.smartindent   = true
-- opt.smoothscroll  = true                  -- nvim >= 0.10
-- opt.spelllang     = { "en" }
-- opt.splitbelow    = true
-- opt.splitkeep     = "screen"
-- opt.splitright    = true
-- opt.statuscolumn  = [[%!v:lua.LazyVim.statuscolumn()]]
-- opt.termguicolors = true
-- opt.timeoutlen    = vim.g.vscode and 1000 or 300  -- which-key trigger delay
-- opt.undofile      = true
-- opt.undolevels    = 10000
-- opt.updatetime    = 200                   -- CursorHold / swap write delay
-- opt.virtualedit   = "block"               -- move freely in visual block
-- opt.wildmode      = "longest:full,full"
-- opt.winminwidth   = 5
-- opt.wrap          = false
