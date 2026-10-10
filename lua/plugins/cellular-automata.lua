-- Purely cosmetic. Kept because it costs nothing now that it is command-lazy.
--
-- BUG FIX: previously had no trigger, and with `defaults = { lazy = true }`
-- in config/lazy.lua the :CellularAutomaton command never even existed.
return {
    "Eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
    keys = {
        { "<leader>fml", "<cmd>CellularAutomaton make_it_rain<cr>", desc = "Make it rain" },
    },
}
