return {
    {
        "sqve/sort.nvim",
        keys = {
            {
                mode = "n",
                "go",
                "<esc><cmd>sort<cr>",
                desc = "sort",
            },
            {
                mode = "v",
                "go",
                "<esc><cmd>sort<cr>",
                desc = "sort",
            },
            -- vnoremap <silent> go <esc><cmd>sort<cr>}
        },
        -- optional setup for overriding defaults.
        config = function()
            require("sort").setup({
                -- Input configuration here.
                -- Refer to the configuration section below for options.
                -- List of delimiters, in descending order of priority, to automatically
                -- sort on.
                delimiters = {
                    ",",
                    "|",
                    ";",
                    ":",
                    "s", -- Space
                    "t", -- Tab
                },
            })
        end,
    },
    {
        "mcauley-penney/visual-whitespace.nvim",
        config = true,
        event = "ModeChanged *:[vV\22]", -- optionally, lazy load on entering visual mode
        opts = {
            enabled = true,
            highlight = { link = "Visual", default = true },
            match_types = {
                space = true,
                tab = true,
                nbsp = true,
                lead = false,
                trail = false,
            },
            list_chars = {
                space = "·",
                tab = "↦",
                nbsp = "␣",
                lead = "‹",
                trail = "›",
            },
            fileformat_chars = {
                unix = "↲",
                mac = "←",
                dos = "↙",
            },
            ignore = { filetypes = {}, buftypes = {} },
        },
    },
    {
        "t3ntxcl3s/ecolog.nvim",
        keys = {
            { "<leader>el", "<Cmd>EcologShelterLinePeek<cr>", desc = "Ecolog peek line" },
            { "<leader>eh", "<Cmd>EcologShellToggle<cr>", desc = "Toggle shell variables" },
            { "<leader>ei", "<Cmd>EcologInterpolationToggle<cr>", desc = "Toggle shell variables" },
            { "<leader>ge", "<cmd>EcologGoto<cr>", desc = "Go to env file" },
            { "<leader>ec", "<cmd>EcologSnacks<cr>", desc = "Open a picker" },
            { "<leader>eS", "<cmd>EcologSelect<cr>", desc = "Switch env file" },
            { "<leader>es", "<cmd>EcologShelterToggle<cr>", desc = "Ecolog shelter toggle" },
        },
        lazy = false,
        opts = {
            preferred_environment = "local",
            types = true,
            providers = {
                {
                    pattern = "{{[%w_]+}}?$",
                    filetype = "http",
                    extract_var = function(line, col)
                        local utils = require("ecolog.utils")
                        return utils.extract_env_var(line, col, "{{([%w_]+)}}?$")
                    end,
                    get_completion_trigger = function()
                        return "{{"
                    end,
                },
            },
            interpolation = {
                enabled = true,
                features = {
                    commands = false,
                },
            },
            sort_var_fn = function(a, b)
                if a.source == "shell" and b.source ~= "shell" then
                    return false
                end
                if a.source ~= "shell" and b.source == "shell" then
                    return true
                end

                return a.name < b.name
            end,
            integrations = {
                lspsaga = true,
                blink_cmp = true,
                statusline = {
                    hidden_mode = true,
                    highlights = {
                        env_file = "Directory",
                        vars_count = "Number",
                    },
                },
                snacks = true,
            },
            shelter = {
                configuration = {
                    sources = {
                        [".env.example"] = "none",
                    },
                    partial_mode = {
                        min_mask = 5,
                        show_start = 1,
                        show_end = 1,
                    },
                    mask_char = "*",
                },
                modules = {
                    files = true,
                    peek = false,
                    snacks_previewer = true,
                    snacks = false,
                    cmp = true,
                },
            },
            path = vim.fn.getcwd(),
        },
    },
    {
        "bennypowers/nvim-regexplainer",
        config = function()
            require("regexplainer").setup()
        end,
        dependecies = {
            "nvim-treesitter/nvim-treesitter",
            "MunifTanjim/nui.nvim",
        },
    },
}
