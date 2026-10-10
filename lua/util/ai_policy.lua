-- The AI provider policy, shared by every plugin that can reach a model.
-- Rationale lives in the PROVIDER POLICY block of plugins/sidekick.lua and in
-- the README: Copilot is always permitted; a direct-vendor tool is permitted
-- only when its API key is present in the environment.
local M = {}

-- Direct-vendor tools and the environment variable that makes each usable.
-- Absent key => tool is not offered.
M.direct_vendor_tools = {
    claude = "ANTHROPIC_API_KEY",
    codex = "OPENAI_API_KEY",
    opencode = "OPENROUTER_API_KEY",
}

---Tools that may be offered: Copilot always, direct-vendor tools only when
---their API key is present in the environment.
---@return table<string, boolean>
function M.permitted()
    local ok = { copilot = true }
    for tool, env in pairs(M.direct_vendor_tools) do
        local key = vim.env[env]
        ok[tool] = key ~= nil and key ~= ""
    end
    return ok
end

return M
