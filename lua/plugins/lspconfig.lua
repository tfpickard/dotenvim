return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "jose-elias-alvarez/typescript.nvim",
    init = function()
      require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
        vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        -- Python specific keymaps
        vim.keymap.set("n", "<leader>rf", ":PyrightOrganizeImports<CR>", { desc = "Organize Imports", buffer = buffer })
        vim.keymap.set("n", "<leader>rr", ":PyrightRestart<CR>", { desc = "Restart Pyright", buffer = buffer })
      end)
    end,
  },
  ---@class PluginLspOpts
  opts = {
    ---@type lspconfig.options
    servers = {
      -- tsserver will be automatically installed with mason and loaded with lspconfig
      tsserver = {},
      pyright = {},
    },
    -- you can do any additional lsp server setup here
    -- return true if you don't want this server to be setup with lspconfig
    ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
    setup = {
      -- example to setup with typescript.nvim
      tsserver = function(_, opts)
        require("typescript").setup({ server = opts })
        return true
      end,
      -- example to setup with pyright
      pyright = function(_, opts)
        -- Customize pyright settings here
        opts.settings = {
          python = {
            analysis = {
              typeCheckingMode = "strict",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        }
        return true
      end,
      -- ["*"] = function(server, opts) end,
    },
  },
}
