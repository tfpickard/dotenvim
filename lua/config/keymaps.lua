-- Keymaps are automatically loaded on the VeryLazy event.
--
-- IMPORTANT: this file intentionally contains ONLY keymaps that LazyVim does
-- not already provide. LazyVim's defaults live in
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- and are loaded before this file.
--
-- Copying LazyVim's defaults here is actively harmful: user keymaps load last,
-- so stale copies silently *override* upstream fixes. This file previously
-- carried 76 verbatim copies, including a `vim.diagnostic.goto_next` version
-- (deprecated in Neovim 0.11) that shadowed LazyVim's modern
-- `vim.diagnostic.jump` implementation and dropped its v:count1 support.
local map = vim.keymap.set

-- Oil: edit the filesystem like a buffer
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Keep the old icon-picker muscle memory, but route it through Snacks.
map("n", "<leader>ii", function()
    Snacks.picker.icons()
end, { desc = "Icon Picker" })

-- Split a line and place the second half above the first half
map("n", "<leader>kl", "d$O<Esc>p==", { desc = "Split Line Above" })

-- Quit variants (LazyVim only ships <leader>qq)
map({ "i", "x", "n", "s" }, "<C-q>", "<cmd>q<cr><esc>", { desc = "Quit" })
map("n", "<leader>wq", "<cmd>wqa<cr>", { desc = "Save and Quit All" })
map("n", "<leader>q!", "<cmd>qa!<cr>", { desc = "Force Quit All" })

-- Terminal mode: LazyVim defines no t-mode maps, so these are ours.
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │ REFERENCE — LazyVim defaults (already active; listed for discoverability) │
-- ╰──────────────────────────────────────────────────────────────────────────╯
-- Do NOT re-declare these here. This file loads *after* LazyVim, so a copy
-- shadows upstream. (That is exactly how this config ended up running a
-- `vim.diagnostic.goto_next` version that Neovim 0.11 deprecated, hiding
-- LazyVim's `vim.diagnostic.jump` implementation and its v:count1 support.)
-- To change one, remap it in a plugin spec or map it to something else.
--
--  Movement / windows
--    j k <Down> <Up>     display-line aware motion (respects v:count)
--    <C-h/j/k/l>         focus window left/down/up/right
--    <C-Up/Down/Left/Right>  resize window
--    <leader>-  <leader>|    split below / right
--    <leader>wd              close window
--    <leader>wm <leader>uZ   zoom window     <leader>uz  zen mode
--
--  Buffers / tabs
--    <S-h> <S-l> [b ]b   prev / next buffer
--    <leader>bb  <leader>`   alternate buffer
--    <leader>bd  <leader>bo  <leader>bD  delete buffer / others / buf+window
--    <leader><tab>{<tab>,d,[,],f,l,o}    new/close/prev/next/first/last/only tab
--
--  Editing
--    <A-j> <A-k>         move line(s) down / up   (n, i, v)
--    < >                 indent and keep selection (v)
--    gco gcO             add comment below / above
--    , . ;               insert-mode undo break-points
--    <C-s>               save file
--
--  Search / diagnostics / lists
--    n N                 next/prev search result, direction-normalised
--    <esc>               clear hlsearch (+ stop snippet)
--    <leader>ur          redraw / clear hlsearch / diff update
--    ]d [d  ]e [e  ]w [w next/prev diagnostic / error / warning
--    <leader>cd          line diagnostics       <leader>cf  format
--    <leader>xq <leader>xl  toggle quickfix / location list
--    ]q [q               next / prev quickfix item
--
--  Git (Snacks)
--    <leader>gg <leader>gG   lazygit (root / cwd)
--    <leader>gb              blame line        <leader>gf  file history
--    <leader>gl <leader>gL   git log (root / cwd)
--    <leader>gB <leader>gY   browse / copy remote URL
--
--  Toggles (<leader>u…)  — all via Snacks.toggle
--    uf uF format (buffer/global)   us spell      uw wrap      uL relativenumber
--    ud diagnostics                 ul number     uc conceal   uA tabline
--    uT treesitter                  ub background uD dim       ua animate
--    ug indent guides               uS scroll     uh inlay hints
--    ui inspect pos                 uI inspect treesitter tree
--
--  Misc
--    <leader>l  Lazy      <leader>L  LazyVim changelog   <leader>K  keywordprg
--    <leader>fn new file  <leader>qq quit all
--    <leader>ft <leader>fT  terminal (root / cwd)   <c-/>  terminal
--    <leader>dpp <leader>dph  snacks profiler / highlights
