return {
    {
        "mistweaverco/kulala.nvim",
        ft = { "http", "rest" },
        keys = {
            { "<leader>Hs", desc = "HTTP Send Request" },
            { "<leader>Ha", desc = "HTTP Send All Requests" },
            { "<leader>Hr", desc = "HTTP Replay Last Request" },
            { "<leader>Hb", desc = "HTTP Scratchpad" },
            { "<leader>Ho", desc = "HTTP Open Kulala" },
            { "<leader>Hf", desc = "HTTP Find Request" },
            { "<leader>He", desc = "HTTP Select Environment" },
            { "<leader>Ht", desc = "HTTP Toggle Headers/Body" },
        },
        opts = {
            global_keymaps = {
                ["Open scratchpad"] = {
                    "<leader>Hb",
                    function()
                        require("kulala").scratchpad()
                    end,
                    desc = "HTTP Scratchpad",
                },
                ["Open kulala"] = {
                    "<leader>Ho",
                    function()
                        require("kulala").open()
                    end,
                    desc = "HTTP Open Kulala",
                },
                ["Send request"] = {
                    "<leader>Hs",
                    function()
                        require("kulala").run()
                    end,
                    mode = { "n", "v" },
                    desc = "HTTP Send Request",
                },
                ["Send all requests"] = {
                    "<leader>Ha",
                    function()
                        require("kulala").run_all()
                    end,
                    mode = { "n", "v" },
                    desc = "HTTP Send All Requests",
                },
                ["Replay the last request"] = {
                    "<leader>Hr",
                    function()
                        require("kulala").replay()
                    end,
                    desc = "HTTP Replay Last Request",
                },
                ["Find request"] = {
                    "<leader>Hf",
                    function()
                        require("kulala").search()
                    end,
                    ft = { "http", "rest" },
                    desc = "HTTP Find Request",
                },
                ["Select environment"] = {
                    "<leader>He",
                    function()
                        require("kulala").set_selected_env()
                    end,
                    ft = { "http", "rest" },
                    desc = "HTTP Select Environment",
                },
                ["Toggle headers/body"] = {
                    "<leader>Ht",
                    function()
                        require("kulala").toggle_view()
                    end,
                    ft = { "http", "rest" },
                    desc = "HTTP Toggle Headers/Body",
                },
            },
        },
    },
}
