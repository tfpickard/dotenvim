return {
  "mason-org/mason.nvim",
  opts = {
    install_root_dir = vim.fn.stdpath("data") .. "/mason",
    PATH = "append", -- ensure mason/bin is on PATH
  },
  config = function(_, opts)
    require("mason").setup(opts)

    -- Link tools to ~/.local/share/bin
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
    local target_bin = vim.fn.stdpath("data") .. "/bin"
    vim.fn.mkdir(target_bin, "p")

    for _, file in ipairs(vim.fn.glob(mason_bin .. "/*", 0, 1)) do
      local link = target_bin .. "/" .. vim.fn.fnamemodify(file, ":t")
      if vim.fn.filereadable(file) == 1 and vim.fn.filereadable(link) == 0 then
        vim.fn.system({ "ln", "-s", file, link })
      end
    end
  end,
}
