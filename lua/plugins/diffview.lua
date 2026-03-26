return {
    {
        "sindrets/diffview.nvim",
        cmd = {
            "DiffviewOpen",
            "DiffviewClose",
            "DiffviewToggleFiles",
            "DiffviewFocusFiles",
            "DiffviewRefresh",
            "DiffviewFileHistory",
        },
        keys = {
            {
                "<leader>gd",
                "<cmd>DiffviewOpen<cr>",
                desc = "Git Diff View",
            },
            {
                "<leader>gD",
                "<cmd>DiffviewClose<cr>",
                desc = "Git Diff View Close",
            },
            {
                "<leader>gh",
                "<cmd>DiffviewFileHistory %<cr>",
                desc = "Git File History",
            },
            {
                "<leader>gH",
                "<cmd>DiffviewFileHistory<cr>",
                desc = "Git Repo History",
            },
        },
        opts = {
            view = {
                default = {
                    layout = "diff2_horizontal",
                },
                file_history = {
                    layout = "diff2_horizontal",
                },
            },
            file_panel = {
                win_config = {
                    position = "left",
                    width = 36,
                },
            },
            file_history_panel = {
                win_config = {
                    position = "bottom",
                    height = 14,
                },
            },
        },
    },
}
