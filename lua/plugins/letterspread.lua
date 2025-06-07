return {
    "tfpickard/letterspread.nvim",
    build = "make install",
    event = "VeryLazy",
    config = function()
        require("letterspread").setup({
            anagrams = {
                min_word_length = 4,
                include_semantic_similarity = true,
                filter_by_frequency = true,
            },
            poetry = {
                default_type = "haiku",
                use_rhymes = true,
                preserve_sentiment = true,
            },
            wordsearch = {
                grid_size_min = 20,
                grid_size_max = 30,
                max_words = 25,
                use_semantic_groups = true,
            },
            keymaps = {
                anagrams = "<leader>ta",
                poetry = "<leader>tp",
                wordsearch = "<leader>ts",
            },
            window = {
                border = "double",
                relative = "editor",
            },
        })
    end,
}
