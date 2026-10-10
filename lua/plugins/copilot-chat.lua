-- CopilotChat.nvim -- chat window for GitHub Copilot. It talks only to
-- Copilot, so it sits inside the AI provider policy by construction.
--
-- It can't read the auth.db login copilot.lua uses, so the first chat runs a
-- one-time GitHub device login; the token is kept in
-- stdpath("data")/copilot_chat/tokens.json.
--
-- The base spec comes from `lazyvim.plugins.extras.ai.copilot-chat` (enabled
-- in lazyvim.json). Its keys sit on <leader>a{a,x,q,p}, and aa/ap collide with
-- sidekick, so all of them move under <leader>ac with the same final letter:
-- <leader>aca toggle, acx clear, acq quick chat, acp prompt actions.
return {
    "CopilotC-Nvim/CopilotChat.nvim",
    -- Required via plenary.curl/plenary.async; the extra doesn't declare it.
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = function(_, keys)
        return vim.tbl_map(function(k)
            k = vim.deepcopy(k)
            k[1] = (k[1]:gsub("^<leader>a(.+)$", "<leader>ac%1"))
            return k
        end, keys)
    end,
}
