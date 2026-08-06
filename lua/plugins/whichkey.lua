-- Register readable group names for the custom leader prefixes this config
-- adds, so they show up nicely in the which-key popup instead of as a wall of
-- raw keys.
return {
    "folke/which-key.nvim",
    opts = {
        spec = {
            { "<leader>R", group = "sshiv (remote exec)", icon = " " },
            { "<leader>H", group = "http (kulala)", icon = "󰖟 " },
            { "<leader>e", group = "ecolog (env)", icon = " " },
        },
    },
}
