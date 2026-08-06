-- sidekick.nvim -- the one AI plugin that does something autocomplete can't.
--
-- Two distinct features, both backed by the Copilot subscription you're
-- already authenticated to (no extra API keys, no second provider):
--
--  1. NES (Next Edit Suggestions). Ordinary completion only predicts what
--     comes after the cursor. NES uses the Copilot LSP to predict your next
--     *edit* -- anywhere in the file -- and shows it as an inline diff. Rename
--     a struct field and it offers the matching updates at the other call
--     sites. <Tab> in normal mode jumps to it, <Tab> again applies it.
--
--  2. An embedded AI CLI terminal that shares buffer/selection context with a
--     running agent (<leader>aa). `copilot` is on PATH here.
--
-- ── PROVIDER POLICY ─────────────────────────────────────────────────────────
-- This config serves both a work and a personal machine.
--
-- At work, GitHub Copilot must be the AI *provider*. That's a constraint on
-- the vendor, not the model. Claude Opus 5, GPT-5.6 and the other flagship
-- models Copilot brokers are all still Copilot, so the `copilot` CLI is always
-- available and its model picker is left unrestricted.
--
-- What must not happen at work is talking to Anthropic/OpenAI/OpenRouter
-- *directly*. Those CLIs authenticate from an API key in the environment, so
-- the key's presence is used as the capability check:
--
--     claude    -> requires ANTHROPIC_API_KEY
--     codex     -> requires OPENAI_API_KEY
--     opencode  -> requires OPENROUTER_API_KEY
--
-- On the work machine those variables are unset, so those tools are filtered
-- out of the picker entirely and cannot be selected by accident. No marker
-- file, no manual toggle to forget to flip -- the environment *is* the policy,
-- so a work machine is correct by default and a personal machine lights the
-- extra tools up on its own.
--
-- Gemini is deliberately not listed.
--
-- No API keys live in this repo; each CLI reads its own credentials from the
-- environment exactly as it does in a shell.
--
-- The base spec is `lazyvim.plugins.extras.ai.sidekick` (enabled in
-- lazyvim.json), which wires ai_nes into blink's <Tab> chain and adds a
-- lualine status indicator. This file tunes it and applies the policy.
--
-- Note on <Tab>: the extra maps it in normal mode via an expr map that falls
-- through to a literal <Tab> when no suggestion is pending, so <C-i>
-- jumplist-forward keeps working.

-- Direct-vendor CLIs and the environment variable that makes each usable.
-- Absent key => tool is filtered out of the picker.
local direct_vendor_tools = {
    claude = "ANTHROPIC_API_KEY",
    codex = "OPENAI_API_KEY",
    opencode = "OPENROUTER_API_KEY",
}

---Tools that may be offered here: Copilot always, direct-vendor CLIs only
---when their API key is present in the environment.
---@return table<string, boolean>
local function permitted_tools()
    local ok = { copilot = true }
    for tool, env in pairs(direct_vendor_tools) do
        local key = vim.env[env]
        ok[tool] = key ~= nil and key ~= ""
    end
    return ok
end

---Pick from the tools that are BOTH permitted by policy and actually
---installed, then hand the choice to sidekick.
---@param action fun(opts: table)
local function pick_tool(action)
    local permitted = permitted_tools()
    local State = require("sidekick.cli.state")
    local choices = {}
    for _, state in ipairs(State.get({ installed = true })) do
        local name = state.tool and state.tool.name
        if name and permitted[name] then
            table.insert(choices, name)
        end
    end
    table.sort(choices)

    if #choices == 0 then
        return vim.notify(
            "No permitted AI CLI is installed.\nCopilot CLI: https://github.com/github/copilot-cli",
            vim.log.levels.WARN,
            { title = "Sidekick" }
        )
    end
    if #choices == 1 then
        return action({ name = choices[1] })
    end
    vim.ui.select(choices, { prompt = "AI CLI:" }, function(choice)
        if choice then
            action({ name = choice })
        end
    end)
end

return {
    "folke/sidekick.nvim",
    -- The LazyVim extra only declares `keys`, which makes the plugin
    -- key-lazy -- NES would stay dormant until you happened to press one of
    -- them (verified: `sidekick.nes.enabled == false` after opening a file).
    -- VeryLazy arms NES for every buffer without touching startup time.
    event = "VeryLazy",
    opts = {
        nes = {
            -- enabled: defaults to a function honouring vim.g/vim.b
            -- sidekick_nes, so you can disable per-buffer with
            --   :lua vim.b.sidekick_nes = false
            -- or globally via the <leader>uN toggle the extra registers.
            debounce = 100, -- ms after a change before requesting a suggestion
            trigger = {
                events = { "ModeChanged i:n", "TextChanged", "User SidekickNesDone" },
            },
            clear = {
                events = { "TextChangedI", "InsertEnter" },
                esc = true, -- <Esc> dismisses the pending suggestion
            },
            diff = {
                inline = "words", -- "words" | "chars" | false
                -- Only render the diff when the cursor is at the edit site.
                -- "always" litters the buffer with virtual text while you
                -- read, fighting the indent guides and the
                -- treesitter-context header.
                show = "cursor",
            },
            signs = true, -- gutter sign marking the suggested edit
            jumplist = true, -- jumping to a suggestion is undoable with <C-o>
        },

        cli = {
            watch = true, -- reload buffers the CLI edits underneath you
            win = {
                layout = "right", -- "float"|"left"|"right"|"top"|"bottom"
                split = { width = 90, height = 20 },
                float = { width = 0.9, height = 0.9 },
            },
        },
    },
    keys = {
        -- Override the extra's <leader>aa/<leader>as so the choice of CLI goes
        -- through the policy filter above instead of the full default list.
        {
            "<leader>aa",
            function()
                pick_tool(function(o)
                    require("sidekick.cli").toggle(o)
                end)
            end,
            desc = "Sidekick Toggle CLI",
        },
        {
            "<leader>as",
            function()
                pick_tool(function(o)
                    require("sidekick.cli").focus(o)
                end)
            end,
            desc = "Select CLI",
        },
        {
            "<leader>aP",
            function()
                local permitted, lines = permitted_tools(), {}
                for tool, env in pairs(direct_vendor_tools) do
                    table.insert(
                        lines,
                        ("  %-9s %-20s %s"):format(
                            tool,
                            env,
                            permitted[tool] and "available" or "unset -> hidden"
                        )
                    )
                end
                table.sort(lines)
                vim.notify(
                    "copilot: always available (any model Copilot brokers)\n"
                        .. table.concat(lines, "\n"),
                    vim.log.levels.INFO,
                    { title = "AI provider policy" }
                )
            end,
            desc = "AI Provider Policy",
        },
    },
}
