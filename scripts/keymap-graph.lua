--
-- keymap-graph -- render Neovim's multi-key mappings as a Mermaid graph.
--
-- Multi-key mappings form a prefix tree: `<leader>g` is a branch point, and
-- `<leader>gg` / `<leader>gb` / `<leader>gl` are its leaves. which-key shows
-- one level of that tree at a time; this draws the whole thing at once, which
-- is what you want when auditing for collisions or printing a cheatsheet.
--
-- Usage: drive it through the wrapper, which handles the Neovim invocation:
--
--   scripts/keymap-graph > maps.mmd
--   scripts/keymap-graph --prefix '<leader>g' --format md > git.md
--   scripts/keymap-graph --mode v
--   scripts/keymap-graph --list-prefixes
--
-- Notes:
--  * Deliberately runs under `--headless`, NOT `nvim -l`. Script mode does not
--    bootstrap lazy.nvim, so it sees only ~46 built-in maps and zero <leader>
--    maps; headless loads the real config and sees all 345. Sourcing init.lua
--    by hand doesn't help -- lazy defers registration to VeryLazy, which
--    script mode never fires.
--  * Lazy-loaded plugins that declare `keys = {...}` are pre-registered by
--    lazy.nvim, so they appear even before the plugin loads.
--  * Buffer-local mappings (most LSP maps) only exist in a buffer with a
--    server attached, so they are not included.

local M = {}

local HELP = [[
keymap-graph -- render Neovim's multi-key mappings as a Mermaid graph

  keymap-graph [options]

  --mode <m>        mode to graph (n v x o i c t s)      default n
  --prefix <keys>   only graph this subtree, e.g. '<leader>g'
  --min-depth <n>   minimum sequence length              default 2
  --max-nodes <n>   cap on rendered nodes                default 400
  --direction <d>   LR TD RL BT                          default LR
  --format <f>      mermaid | md                         default mermaid
  --all             include single-key mappings
  --list-prefixes   list prefixes and their child counts
  --out <file>      write to file instead of stdout
]]

-- ── Argument parsing ────────────────────────────────────────────────────────

local function parse_args(argv)
    local opts = {
        mode = "n",
        min_depth = 2,
        max_nodes = 400,
        direction = "LR",
        format = "mermaid",
    }
    local i = 1
    while i <= #argv do
        local a = argv[i]
        local function val()
            i = i + 1
            if argv[i] == nil then
                error("missing value for " .. a)
            end
            return argv[i]
        end
        if a == "--mode" then
            opts.mode = val()
        elseif a == "--prefix" then
            opts.prefix = val()
        elseif a == "--min-depth" then
            opts.min_depth = tonumber(val()) or 2
        elseif a == "--max-nodes" then
            opts.max_nodes = tonumber(val()) or 400
        elseif a == "--direction" then
            opts.direction = val()
        elseif a == "--format" then
            opts.format = val()
        elseif a == "--out" then
            opts.out = val()
        elseif a == "--all" then
            opts.all = true
            opts.min_depth = 1
        elseif a == "--list-prefixes" then
            opts.list_prefixes = true
        elseif a == "-h" or a == "--help" then
            opts.help = true
        else
            error("unknown argument: " .. a)
        end
        i = i + 1
    end
    return opts
end

-- ── Key tokenising ──────────────────────────────────────────────────────────

--- Split a key sequence into individual keys.
--- Must be token-aware, not byte-wise: "<leader>gg" is three keys
--- (<leader>, g, g) and "<C-w>h" is two. Naive per-character splitting would
--- shatter every <...> form into meaningless fragments.
---@param lhs string
---@return string[]
function M.tokenise(lhs)
    local keys, i = {}, 1
    while i <= #lhs do
        if lhs:sub(i, i) == "<" then
            local close = lhs:find(">", i + 1, true)
            -- A "<" that never closes is a literal key, not a token.
            if close then
                keys[#keys + 1] = lhs:sub(i, close)
                i = close + 1
            else
                keys[#keys + 1] = "<"
                i = i + 1
            end
        else
            -- Advance a whole UTF-8 character so multibyte lhs values aren't
            -- split mid-codepoint.
            local last = vim.str_utf_end(lhs, i) + i
            keys[#keys + 1] = lhs:sub(i, last)
            i = last + 1
        end
    end
    return keys
end

--- Normalise a raw lhs for display. nvim_get_keymap reports the *resolved*
--- key, so a leader mapping comes back as a literal space; turn it back into
--- "<leader>" so the graph groups keys the way you think about them.
---@param lhs string
---@return string
local function normalise(lhs)
    local leader = vim.g.mapleader or "\\"
    if lhs:sub(1, #leader) == leader then
        return "<leader>" .. lhs:sub(#leader + 1)
    end
    return lhs
end

-- ── Collecting mappings ─────────────────────────────────────────────────────

---@param mode string
---@return table[]
function M.collect(mode)
    local out = {}
    for _, m in ipairs(vim.api.nvim_get_keymap(mode)) do
        -- Skip <Plug> mappings and abbreviations: implementation details that
        -- are never typed directly, and would swamp the graph.
        if not m.lhs:match("^<Plug>") and m.abbr ~= 1 then
            local desc = m.desc
            if not desc or desc == "" then
                -- Fall back to the rhs so a node is never blank.
                desc = type(m.rhs) == "string" and m.rhs or (m.callback and "<lua>" or "")
            end
            local lhs = normalise(m.lhs)
            out[#out + 1] = { keys = M.tokenise(lhs), lhs = lhs, desc = desc }
        end
    end
    return out
end

-- ── Tree building ───────────────────────────────────────────────────────────

---@param entries table[]
---@param opts table
---@return table root
function M.build_tree(entries, opts)
    local root = { children = {} }
    local prefix_keys = opts.prefix and M.tokenise(normalise(opts.prefix)) or nil

    for _, e in ipairs(entries) do
        local keys = e.keys
        local include = #keys >= opts.min_depth

        -- --prefix: keep only sequences under that subtree, and graph them
        -- relative to it so the diagram isn't dominated by a shared stem.
        if include and prefix_keys then
            for idx, pk in ipairs(prefix_keys) do
                if keys[idx] ~= pk then
                    include = false
                    break
                end
            end
            if include then
                if #keys <= #prefix_keys then
                    include = false
                else
                    keys = vim.list_slice(keys, #prefix_keys + 1, #keys)
                end
            end
        end

        if include then
            local node = root
            for _, key in ipairs(keys) do
                node.children[key] = node.children[key] or { children = {} }
                node = node.children[key]
            end
            -- A sequence can be both a leaf and an interior node (`gs` acts,
            -- `gss` also acts); storing desc on the interior node surfaces it.
            node.desc = e.desc
            node.lhs = e.lhs
        end
    end
    return root
end

-- ── Mermaid rendering ───────────────────────────────────────────────────────

--- Escape text for a Mermaid node label. Mermaid is punctuation-sensitive, so
--- quotes and angle brackets are entity-escaped or the diagram won't parse.
---@param s string
---@return string
local function esc(s)
    s = tostring(s or "")
    s = s:gsub("&", "&amp;"):gsub('"', "&quot;"):gsub("<", "&lt;"):gsub(">", "&gt;")
    s = s:gsub("[\r\n]+", " ")
    if vim.fn.strchars(s) > 46 then
        s = vim.fn.strcharpart(s, 0, 45) .. "…"
    end
    return s
end

---@param root table
---@param opts table
---@return string[]
function M.render(root, opts)
    local lines = { ("graph %s"):format(opts.direction) }
    local id, count, truncated = 0, 0, false

    -- Sort children so identical config always yields an identical diagram,
    -- which keeps the output diffable in git.
    local function sorted_keys(tbl)
        local ks = vim.tbl_keys(tbl)
        table.sort(ks)
        return ks
    end

    local function walk(node, parent_id)
        for _, key in ipairs(sorted_keys(node.children)) do
            if count >= opts.max_nodes then
                truncated = true
                return
            end
            local child = node.children[key]
            id = id + 1
            count = count + 1
            local nid = "n" .. id
            local is_leaf = vim.tbl_isempty(child.children)

            local label = (child.desc and child.desc ~= "")
                    and ("%s — %s"):format(esc(key), esc(child.desc))
                or esc(key)

            -- Shape encodes role: rounded = does something, square = prefix.
            if is_leaf or child.desc then
                lines[#lines + 1] = ('    %s("%s")'):format(nid, label)
                lines[#lines + 1] = ("    class %s action;"):format(nid)
            else
                lines[#lines + 1] = ('    %s["%s"]'):format(nid, label)
                lines[#lines + 1] = ("    class %s prefix;"):format(nid)
            end
            lines[#lines + 1] = ("    %s --> %s"):format(parent_id, nid)

            walk(child, nid)
        end
    end

    lines[#lines + 1] = ('    root(["%s"])'):format(esc(opts.prefix or (opts.mode .. "-mode")))
    lines[#lines + 1] = "    class root root;"
    walk(root, "root")

    lines[#lines + 1] =
        "    classDef root fill:#bd5eff,stroke:#5ef1ff,color:#16181a,font-weight:bold;"
    lines[#lines + 1] = "    classDef prefix fill:#1e2124,stroke:#7b8496,color:#b3bccb;"
    lines[#lines + 1] = "    classDef action fill:#16181a,stroke:#5eff6c,color:#ffffff;"

    if truncated then
        lines[#lines + 1] = ("    %%%% truncated at --max-nodes=%d"):format(opts.max_nodes)
    end
    return lines
end

-- ── Prefix listing ──────────────────────────────────────────────────────────

local function list_prefixes(entries)
    local counts = {}
    for _, e in ipairs(entries) do
        if #e.keys >= 2 then
            counts[e.keys[1]] = (counts[e.keys[1]] or 0) + 1
        end
    end
    local ks = vim.tbl_keys(counts)
    table.sort(ks, function(a, b)
        if counts[a] ~= counts[b] then
            return counts[a] > counts[b]
        end
        return a < b
    end)
    local out = {}
    for _, k in ipairs(ks) do
        out[#out + 1] = ("%-12s %d mappings"):format(k, counts[k])
    end
    return out
end

-- ── Main ────────────────────────────────────────────────────────────────────

--- `nvim -l` runs the script *after* init.lua but without a UI, so the
--- VeryLazy event never fires and lazy.nvim never registers the keymaps that
--- most plugins (and LazyVim itself) contribute. Firing it explicitly and
--- waiting for the handlers is what makes the graph reflect a real session
--- rather than just the handful of maps set directly in init.
local function load_plugin_keymaps()
    pcall(vim.api.nvim_exec_autocmds, "User", { pattern = "VeryLazy", modeline = false })
    -- lazy.nvim schedules its keymap registration, so yield until the count
    -- stops growing (bounded, so a broken plugin can't hang the script).
    local last, stable = -1, 0
    for _ = 1, 100 do
        vim.wait(50)
        local n = #vim.api.nvim_get_keymap("n")
        if n == last then
            stable = stable + 1
            if stable >= 3 then
                break
            end
        else
            stable, last = 0, n
        end
    end
end

--- Args arrive via the environment because `--headless -c` gives no clean
--- argv path; the wrapper sets KEYMAP_GRAPH_ARGS.
local function script_args()
    local raw = vim.env.KEYMAP_GRAPH_ARGS or ""
    local out = {}
    for a in raw:gmatch("%S+") do
        out[#out + 1] = (a:gsub("^\1", ""):gsub("\1", " "))
    end
    return out
end

local function emit(text)
    local dest = vim.env.KEYMAP_GRAPH_OUT
    if dest and dest ~= "" then
        vim.fn.writefile(vim.split(text, "\n"), dest)
    else
        io.write(text)
    end
end

local ok, err = pcall(function()
    local opts = parse_args(script_args())

    if opts.help then
        emit(HELP)
        return
    end

    load_plugin_keymaps()
    local entries = M.collect(opts.mode)

    if opts.list_prefixes then
        emit(table.concat(list_prefixes(entries), "\n") .. "\n")
        return
    end

    local body = table.concat(M.render(M.build_tree(entries, opts), opts), "\n")

    local text
    if opts.format == "md" then
        text = ("# Keymap graph (`%s` mode%s)\n\n```mermaid\n%s\n```\n"):format(
            opts.mode,
            opts.prefix and (", prefix `" .. opts.prefix .. "`") or "",
            body
        )
    else
        text = body .. "\n"
    end

    if opts.out then
        vim.fn.writefile(vim.split(text, "\n"), opts.out)
        local _, edges = body:gsub("%-%->", "")
        emit(("wrote %s (%d edges)\n"):format(opts.out, edges))
    else
        emit(text)
    end
end)

if not ok then
    -- Strip the "path/to/script.lua:87: " prefix Lua prepends; the file and
    -- line are noise for someone who just mistyped a flag.
    local msg = tostring(err):gsub("^.-%.lua:%d+:%s*", "")
    vim.fn.writefile({ "keymap-graph: " .. msg }, "/dev/stderr")
    vim.cmd("cquit 1")
end
vim.cmd("qa!")
