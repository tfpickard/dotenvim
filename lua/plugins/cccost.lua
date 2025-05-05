return {
  dir = "~/src/cccost.nvim/",
  config = function()
    require("cccost").setup({
      model = "gpt-4o-mini", -- default model
      enabled = true, -- enable tracking by default
      custom_rates = { -- override or add custom rates
        ["custom-model"] = {
          input = 0.02,
          output = 0.04,
        },
      },
    })
  end,
}
