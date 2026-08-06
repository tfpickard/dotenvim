return {
    "catgoose/nvim-colorizer.lua",
    event = "LazyFile",
    opts = {
        -- Was `{ "*" }`, which attaches a colour parser to *every* buffer --
        -- including logs, JSON dumps and other large files where it costs real
        -- redraw time for no benefit. Limit it to filetypes where colour
        -- literals actually appear, plus an explicit exclusion list.
        filetypes = {
            "css", "scss", "sass", "less", "stylus",
            "html", "htmldjango", "javascript", "javascriptreact",
            "typescript", "typescriptreact", "svelte", "vue", "astro",
            "lua", "vim", "toml", "yaml", "json", "jsonc",
            "conf", "config", "dosini", "sh", "bash", "zsh", "fish",
            "tmux", "kitty", "i3config", "rasi", "xdefaults",
            "!lazy", "!mason", "!help", "!checkhealth", "!snacks_picker_list",
            -- Bare colour *names* ("blue", "tan", "gold") are only meaningful
            -- in stylesheets/markup. Enabling them globally makes ordinary
            -- identifiers light up in source code, so opt in per filetype.
            css = { names = true },
            scss = { names = true },
            sass = { names = true },
            less = { names = true },
            html = { names = true },
        },
        -- Don't attach in scratch/terminal/prompt buffers.
        buftypes = { "!prompt", "!nofile", "!terminal" },
        -- Boolean | List of usercommands to enable.  See User commands section.
        user_commands = true, -- Enable all or some usercommands
        -- Schedule highlight setup instead of doing it inline on attach, so
        -- opening a large file does not block on the first paint.
        lazy_load = true,
        user_default_options = {
            -- Off by default; re-enabled per filetype above. Prevents words
            -- like `tan`, `gold` and `orchid` being highlighted in code.
            names = false,
            names_opts = { -- options for mutating/filtering names.
                lowercase = true, -- name:lower(), highlight `blue` and `red`
                camelcase = true, -- name, highlight `Blue` and `Red`
                uppercase = false, -- name:upper(), highlight `BLUE` and `RED`
                strip_digits = false, -- ignore names with digits,
                -- highlight `blue` and `red`, but not `blue3` and `red4`
            },
            -- Expects a table of color name to #RRGGBB value pairs.  # is optional
            -- Example: { cool = "#107dac", ["notcool"] = "ee9240" }
            -- Set to false to disable, for example when setting filetype options
            names_custom = false, -- Custom names to be highlighted: table|function|false
            RGB = true, -- #RGB hex codes
            RGBA = true, -- #RGBA hex codes
            RRGGBB = true, -- #RRGGBB hex codes
            RRGGBBAA = false, -- #RRGGBBAA hex codes
            AARRGGBB = false, -- 0xAARRGGBB hex codes
            rgb_fn = false, -- CSS rgb() and rgba() functions
            hsl_fn = false, -- CSS hsl() and hsla() functions
            css = false, -- Enable all CSS *features*:
            -- names, RGB, RGBA, RRGGBB, RRGGBBAA, AARRGGBB, rgb_fn, hsl_fn
            css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
            -- Tailwind colors.  boolean|'normal'|'lsp'|'both'.  True sets to 'normal'
            tailwind = false, -- Enable tailwind colors
            tailwind_opts = { -- Options for highlighting tailwind names
                update_names = false, -- When using tailwind = 'both', update tailwind names from LSP results.  See tailwind section
            },
            -- parsers can contain values used in `user_default_options`
            sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
            -- Highlighting mode.  'background'|'foreground'|'virtualtext'
            mode = "background", -- Set the display mode
            -- Virtualtext character to use
            virtualtext = "■",
            -- Display virtualtext inline with color.  boolean|'before'|'after'.  True sets to 'after'
            virtualtext_inline = false,
            -- Virtualtext highlight mode: 'background'|'foreground'
            virtualtext_mode = "foreground",
            -- update color values even if buffer is not focused
            -- example use: cmp_menu, cmp_docs
            always_update = false,
            -- hooks to invert control of colorizer
            hooks = {
                -- called before line parsing.  Accepts boolean or function that returns boolean
                -- see hooks section below
                disable_line_highlight = false,
            },
        },
    },
}
