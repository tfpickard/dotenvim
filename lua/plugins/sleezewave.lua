-- return {}
return {
    "tfpickard/sleezwave.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("sleezwave").setup()
        vim.cmd.colorscheme("sleezwave")
    end,
}
