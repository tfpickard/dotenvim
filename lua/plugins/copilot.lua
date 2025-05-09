return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    keys = {
      {
        "<C-J>",
        function()
          require("copilot.suggestion").accept()
        end,
        desc = "Accept Copilot suggestion",
      },
      {
        "<C-K>",
        function()
          require("copilot.suggestion").dismiss()
        end,
        desc = "Dismiss Copilot suggestion",
      },
    },
    opts = {
      -- suggestion = { enabled = false },
      -- panel = { enabled = false },
      -- filetypes = {
      -- markdown = true,
      -- help = true,
      -- },
    },
    config = function(_, opts)
      -- if vim.g.has_internet == false then
      -- vim.g.copilot_enabled = false
      -- return
      -- end
      require("copilot").setup(opts)
      vim.g.copilot_enabled = true
      vim.g.copilot_no_tab_map = true
    end,
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "giuxtaposition/blink-cmp-copilot" },
    opts = {
      sources = {
        default = { "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            kind = "Copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
}
