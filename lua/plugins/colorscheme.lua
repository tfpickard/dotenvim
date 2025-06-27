return {
    {
        "CWood-sdf/pineapple",
        enabled = true,
        dependencies = require("colorscheme.pineapple"),
        opts = {
            installedRegistry = "colorscheme.pineapple",
            colorschemeFile = "after/plugin/theme.lua",
        },
        cmd = "Pineapple",
    },
    {
        "lmantw/themify.nvim",
        lazy = false,
        enabled = true,
        priority = 999,

        config = function()
            require("themify").setup({
                -- Your list of colorschemes.
                "tfpickard/sleezwave.nvim",
                "ray-x/aurora",
                "ray-x/starry.nvim",
                "kvrohit/mellow.nvim",
                "shaunsingh/moonlight.nvim",
                "folke/tokyonight.nvim",
                "rafamadriz/neon",
                "sho-87/kanagawa-paper.nvim",
                "comfysage/evergarden", -- branch = "mega", },
                "nyoom-engineering/oxocarbon.nvim",
                "Everblush/everblush.nvim",
                "rebelot/kanagawa.nvim",
                "maxmx03/FluoroMachine.nvim",
                "ramojus/mellifluous.nvim",
                "zootedb0t/citruszest.nvim",
                "oxfist/night-owl.nvim",
                "scottmckendry/cyberdream.nvim",
                "rktjmp/lush.nvim",
                "xero/miasma.nvim",
                "cryptomilk/nightcity.nvim",
                { "neanias/everforest-nvim" },
                { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },

                -- Built-in colorschemes are also supported.
                -- (Also works with any colorschemes that are installed via other plugin manager, just make sure the colorscheme is loaded before Themify is loaded.)
                "default",
            })
        end,
    },
    {
        "svermeulen/text-to-colorscheme",
        enabled = false,
        config = function()
            require("text-to-colorscheme").setup({
                ai = {
                    openai_api_key = os.getenv("OPENAI_API_KEY"),
                    gpt_model = "gpt-4o",
                },
            })
        end,
    },

    {
        -- add gruvbox
        { "ellisonleao/gruvbox.nvim" },

        -- Configure LazyVim to load gruvbox
        {
            "LazyVim/LazyVim",
            opts = {
                -- colorscheme = "moonfly",
            },
        },
    },
}
