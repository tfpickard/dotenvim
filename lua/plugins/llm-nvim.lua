-- Example lazy.nvim configuration
return {
    {
        "julwrites/llm-nvim",
        -- Optional: Specify dependencies if needed, e.g., for UI components
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            -- Configure the plugin
            require("llm").setup({
                -- Specify the default LLM model to use
                model = "gpt-4o", -- Or 'claude-3-haiku-20240307', 'llama3', etc.

                -- Define a default system prompt (optional)
                system_prompt = "You are a helpful Neovim assistant.",

                -- Disable default key mappings if you prefer to set your own
                -- no_mappings = true,

                -- Enable debug logging (optional)
                debug = false,
            })

            -- Example custom key mappings (if no_mappings = true or for overrides)
            -- vim.keymap.set('n', '<leader>lp', '<Plug>(llm-prompt)', { desc = "LLM Prompt" })
            -- vim.keymap.set('v', '<leader>ls', '<Plug>(llm-selection)', { desc = "LLM Selection" })
            -- vim.keymap.set('n', '<leader>lt', '<Plug>(llm-toggle)', { desc = "LLM Toggle Manager" })
        end,
    },
}
