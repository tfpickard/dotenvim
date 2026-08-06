-- which-key group labels for every custom prefix this config adds.
--
-- which-key automatically discovers any keymap that has a `desc`, so
-- individual keys need nothing here -- what it *can't* infer is the name of a
-- multi-key prefix. Without a `group` entry a prefix shows up as a bare key
-- with an unlabelled submenu, so every custom prefix is registered below.
--
-- (Still the best-in-class tool for this. `mini.clue` is the only real
-- alternative; which-key v3 remains more capable and is what LazyVim wires up
-- out of the box, so there's no reason to switch.)
return {
    "folke/which-key.nvim",
    opts = {
        -- Show a warning for keymaps that overlap with an existing prefix,
        -- which is how the <leader>e Explorer/ecolog collision went unnoticed.
        notify = true,
        spec = {
            { "<leader>R", group = "sshiv (remote exec)", icon = " " },
            { "<leader>H", group = "http (kulala)", icon = "󰖟 " },
            { "<leader>E", group = "env (ecolog)", icon = " " },
            { "<leader>i", group = "insert/pickers", icon = " " },
            { "<leader>k", group = "line surgery", icon = " " },
            { "<leader>r", group = "refactor/lsp", icon = " " },
            { "<leader>a", group = "ai (sidekick)", icon = " ", mode = { "n", "v" } },
            -- Extra members of groups LazyVim already defines
            { "<leader>cb", desc = "Comment box: title" },
            { "<leader>ct", desc = "Comment box: named part" },
            { "<leader>cl", desc = "Comment box: simple line" },
            { "<leader>cm", desc = "Comment box: marked" },
            { "<leader>ux", desc = "Toggle Treesitter Context" },
            { "<leader>uN", desc = "Toggle Sidekick NES" },
            { "<leader>uW", desc = "Toggle Autosave" },
            { "<leader>ge", desc = "Go to env file" },
            -- Non-leader custom verbs, so they're discoverable too
            { "gs", group = "split (by pattern)", mode = { "n", "x" } },
            { "gS", group = "split (interactive)", mode = { "n", "x" } },
            { "go", desc = "Sort", mode = { "n", "x" } },
            { "-", desc = "Open parent directory (Oil)" },
        },
    },
}
