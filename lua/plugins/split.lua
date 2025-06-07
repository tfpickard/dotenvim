return {
    "wurli/split.nvim",
    opts = {
        keymaps = {
            -- Here, gs and gss give a mapping to split lines by commas and
            -- semicolons. This doesn't enter interactive mode.
            ["gs"] = {
                pattern = "[,;]",
                operator_pending = true,
            },
            ["gss"] = {
                pattern = "[,;]",
                operator_pending = false,
            },
            -- Here, gS and gSS give a mapping to enter interactive split mode...
            ["gS"] = {
                interactive = true,
                operator_pending = true,
            },
            ["gSS"] = {
                interactive = true,
                operator_pending = false,
            },
        },
        interactive_options = {
            -- In interactive mode, the user can press ',' to split by commas
            -- and semicolons, or '|' to split by the pipe operator. The
            -- pipe operator pattern also checks if the current line is an
            -- uncommented OCaml line, and if so, puts the pipe at the
            -- start of the line.
            [","] = "[,;]",
            ["|"] = {
                pattern = { "|>", "%%>%%" },
                break_placement = function(line_info, opts)
                    if line_info.filetype == "ocaml" and not line_info.comment then
                        return "before_pattern"
                    end
                    return "after_pattern"
                end,
            },
        },
        keymap_defaults = {
            -- We can also override the plugin defaults for mappings. For
            -- example, this option specifies that if we're writing SQL,
            -- we should put the split pattern at the start of each line
            -- unless we're writing a comment, e.g. for those who style
            -- their SQL like this (the right way):
            --
            --     -- Before splitting
            --     select foo, bar, baz
            --     from table
            --
            --     -- After splitting
            --     select foo
            --         , bar
            --         , baz
            --     from table
            break_placement = function(line_info, opts)
                if line_info.filetype == "sql" and not line_info.comment then
                    return "before_pattern"
                end
                return "after_pattern"
            end,
            -- This applies the default indentation. You can also use "equalprg"
            -- or "lsp" to apply more sophisticated indentation :)
            indenter = "simple",
        },
        -- If you don't want to include the default keymaps you can set this
        -- to `false`
        set_default_mappings = true,
    },
}
