return {
  {
    "lmantw/themify.nvim",
    lazy = false,
    priority = 999,

    config = function()
      require("themify").setup({
        -- Your list of colorschemes.

        "folke/tokyonight.nvim",
        "sho-87/kanagawa-paper.nvim",
        "comfysage/evergarden", -- branch = "mega", },
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
