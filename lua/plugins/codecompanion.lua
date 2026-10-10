-- codecompanion.nvim -- chat buffer, inline assistant and agentic tools,
-- running on GitHub Copilot by default (every interaction's adapter is
-- "copilot" upstream).
--
-- It reuses the Copilot login copilot.lua already has: current
-- copilot-language-server keeps the token in github-copilot/auth.db, which
-- codecompanion reads via `sqlite3` (avante.nvim and CopilotChat.nvim only
-- understand the legacy hosts.json/apps.json).
--
-- AI provider policy (util/ai_policy.lua): `show_presets = false` makes the
-- adapter tables below the *only* adapters, so the ~30 upstream presets --
-- including ACP agents that can authenticate without an API key -- are gone,
-- and any preset added upstream later stays gone (fail closed).

local policy = require("util.ai_policy")

-- Policy tool -> the http/acp adapters that authenticate with its API key.
local vendor_adapters = {
    copilot = { http = { "copilot" }, acp = { "copilot_acp" } },
    claude = { http = { "anthropic" }, acp = { "claude_code" } },
    codex = { http = { "openai" }, acp = { "codex" } },
    opencode = { http = { "openrouter" }, acp = { "opencode" } },
}

---@return table
local function permitted_adapters()
    ---@type table<string, string|table>
    local http = {
        -- Not model providers: web_search defaults to tavily, fetch_webpage
        -- to jina. Kept so those tools still resolve; hidden in the picker
        -- by upstream's default `hidden` list.
        duckduckgo = "duckduckgo",
        jina = "jina",
        markitdown = "markitdown",
        tavily = "tavily",
        opts = { show_presets = false },
    }
    ---@type table<string, string|table>
    local acp = { opts = { show_presets = false } }
    for tool, ok in pairs(policy.permitted()) do
        if ok then
            for _, name in ipairs(vendor_adapters[tool].http) do
                http[name] = name
            end
            for _, name in ipairs(vendor_adapters[tool].acp) do
                acp[name] = name
            end
        end
    end
    return { http = http, acp = acp }
end

return {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0", -- upstream asks for a major-version pin
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
    keys = {
        {
            "<leader>At",
            "<cmd>CodeCompanionChat Toggle<cr>",
            desc = "Toggle Chat",
            mode = { "n", "x" },
        },
        { "<leader>An", "<cmd>CodeCompanionChat<cr>", desc = "New Chat", mode = { "n", "x" } },
        { "<leader>Aa", "<cmd>CodeCompanionActions<cr>", desc = "Actions", mode = { "n", "x" } },
        { "<leader>Ai", ":CodeCompanion<cr>", desc = "Inline Assist", mode = { "n", "x" } },
        {
            "<leader>As",
            "<cmd>CodeCompanionChat Add<cr>",
            desc = "Add Selection to Chat",
            mode = "x",
        },
    },
    opts = function()
        return { adapters = permitted_adapters() }
    end,
}
