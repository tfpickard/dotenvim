# Neovim Configuration

This Neovim configuration is built on top of LazyVim, providing a modern and efficient editing experience. It includes a variety of plugins and custom settings to enhance productivity and support various programming languages.

## Features

- **Auto Formatting**: Automatically formats code on buffer write using the `conform` plugin.
- **Diagnostic Navigation**: Custom key mappings for navigating diagnostics with severity filtering.
- **Autosave**: Automatically saves changes with configurable timeout and hooks using the `sos` plugin.
- **Completion and Snippets**: Enhanced completion with `nvim-cmp` and snippet support via `blink.cmp`.
- **Code Companion**: Integration with OpenAI for chat and inline code suggestions.
- **Language Support**: Configurations for CMake, Docker, JSON, Python, and YAML with LSP support.
- **Editing Enhancements**: Includes plugins for line splitting, undo highlighting, and more.

## Plugins

This configuration includes a wide range of plugins to enhance the Neovim experience. Below is a complete list of plugins used:
● aerial.nvim
● aider.nvim
● alpha-nvim 0.71ms  VimEnter
● automkdir.nvim 0.3ms  start
● avante.nvim 26.12ms  VeryLazy
● better-escape.nvim 0.75ms  start
● blink-cmp-copilot 0.03ms  blink.cmp
● blink.cmp 21.85ms 󰢱 blink.cmp  nvim-lspconfig
● bufferline.nvim 3.24ms  VeryLazy
● cellular-automaton.nvim 0.21ms  start
● chezmoi.vim 0.12ms  start
● clangd_extensions.nvim 0.29ms 󰢱 clangd_extensions  nvim-lspconfig
● cmdline.nvim 0.41ms  start
● copilot.lua 29.79ms  BufReadPost
● dressing.nvim 1.26ms  avante.nvim
● ecolog.nvim 2.2ms  start
● edgy.nvim 9.68ms  VeryLazy
● flash.nvim 1.66ms  VeryLazy
● focus.nvim 1.6ms  start
● friendly-snippets 15.4ms  blink.cmp
● fzf-lua 0.36ms  avante.nvim
● gitsigns.nvim 5.12ms  LazyFile
● gruvbox.nvim 0.1ms  start
● hawtkeys.nvim 0.79ms  start
● illogical.nvim 1.5ms  start
● img-clip.nvim 1.64ms  VeryLazy
● lazy.nvim 29.2ms  init.lua
● lazydev.nvim 0.83ms  lua
● LazyVim 3.15ms  start
● letterspread.nvim 0.58ms  VeryLazy
● lualine.nvim 19.05ms  VeryLazy
● LuaSnip 5.64ms 󰢱 luasnip.loaders.from_vscode  friendly-snippets
● mason-lspconfig.nvim 0.02ms 󰢱 mason-lspconfig  mason-tool-installer.nvim
● mason-tool-installer.nvim 6.17ms  start
● mason.nvim 3.25ms 󰢱 mason-registry  mason-tool-installer.nvim
● mini.ai 1.12ms  VeryLazy
● mini.hipatterns 0.49ms  LazyFile
● mini.icons 0.73ms  oil.nvim
● mini.pairs 1.23ms  VeryLazy
● mini.pick 0.27ms  avante.nvim
● nui.nvim 0.11ms  avante.nvim
● nvim-colorizer.lua 2.3ms  BufReadPre
● nvim-lint 0.47ms  LazyFile
● nvim-lspconfig 46.99ms  LazyFile
● nvim-puppeteer 0.21ms  start
● nvim-regexplainer 2.06ms  start
● nvim-surround 0.24ms  surround-ui.nvim
● nvim-treesitter 5.83ms  start
● nvim-treesitter-textobjects 3.32ms  VeryLazy
● nvim-ts-autotag 1.73ms  LazyFile
● nvim-web-devicons 0.41ms  vgit.nvim
● oil.nvim 2.61ms  start
● persistence.nvim 0.53ms  BufReadPre
● plenary.nvim 0.31ms  hawtkeys.nvim
● project.nvim 1.23ms  VeryLazy
● remote-sshfs.nvim 82.27ms  start
● render-markdown.nvim 12.49ms  avante.nvim
● sleezwave.nvim 2.24ms  start
● smartcolumn.nvim 0.45ms  start
● snacks.nvim 0.86ms  start
● sos.nvim 2.48ms  start
● split.nvim 1.34ms  start
● surround-ui.nvim 3.08ms  start
● telescope.nvim 11.35ms  remote-sshfs.nvim
● themify.nvim 2.46ms  start
● todo-comments.nvim 1.31ms  LazyFile
● tokyonight.nvim 0.44ms 󰢱 tokyonight  LazyVim
● trouble.nvim 5.79ms 󰢱 trouble  lualine.nvim
● ts-comments.nvim 0.49ms  VeryLazy
● typescript.nvim 0.15ms  nvim-lspconfig
● undo-glow.nvim 6.17ms 󰢱 undo-glow  plugins.undo-glow
● vgit.nvim 14.74ms  VimEnter
● vim-illuminate 1.69ms  LazyFile
● visual-whitespace.nvim 5.53ms  ModeChanged \*:[vV]
● which-key.nvim 0.78ms 󰢱 which-key  illogical.nvim
● yanky.nvim 3.56ms  LazyFile

Not Loaded (18)
○ catppuccin
○ chezmoi.nvim  ChezmoiEdit  <leader>sz
○ cmake-tools.nvim
○ comment-box.nvim  <Leader>cm (v)  <Leader>cb  <Leader>cb (v)  <Leader>ct  <Leader>ct (v)  <Leader>cl  <Leader>cm
○ conform.nvim  ConformInfo  <leader>cF  <leader>cF (v)
○ CopilotChat.nvim  CopilotChat  <c-s>  <leader>a  <leader>a (v)  <leader>aa  <leader>aa (v)  <leader>ax  <leader>ax (v)  <leader>aq  <leader>aq (v)  <leader>ap  <leader>ap (v)
○ dial.nvim  <C-a>  <C-x>  <C-a> (v)  <C-x> (v)  g<C-a>  g<C-a> (v)  g<C-x>  g<C-x> (v)
○ grug-far.nvim  GrugFar  <leader>sr  <leader>sr (v)
○ gruvbox  pineapple
○ harpoon  <leader>h  <leader>1  <leader>2  <leader>3  <leader>4  <leader>5  <leader>H
○ inc-rename.nvim  IncRename
○ markdown-preview.nvim  MarkdownPreview  MarkdownPreviewStop  MarkdownPreviewToggle  <leader>cp
○ nerdy.nvim  Nerdy
○ pineapple  Pineapple
○ SchemaStore.nvim
○ sort.nvim  go  go (v)
○ venv-selector.nvim  VenvSelect  python  <leader>cv
○ vim-startuptime  StartupTime

Disabled (12)
○ codecompanion.nvim
○ hardtime.nvim
○ llm-nvim
○ noice.nvim
○ nvim-cmp
○ nvim-comment-frame
○ nvim-dev-container
○ nvim-snippets
○ pathcheck.nvim
○ spaceport.nvim
○ stopinsert.nvim
○ text-to-colorscheme

These plugins are configured to provide a comprehensive development environment with support for various languages, tools, and utilities.

## Custom Key Mappings

- **Diagnostic Navigation**: Use `<leader>gY` to browse Git URLs and navigate diagnostics.
- **Ecolog Commands**: Various key mappings under `<leader>e` for managing environment variables.
- **Split Lines**: Use `gs` and `gss` to split lines by commas and semicolons.

## Installation

1. Ensure you have Neovim installed.
2. Clone this repository into your Neovim configuration directory.
3. Launch Neovim and run `:PackerSync` to install plugins.

## Configuration

This setup is highly customizable. You can modify the configuration files in the `lua/config` and `lua/plugins` directories to suit your needs.

## Contributing

Feel free to open issues or submit pull requests for improvements or bug fixes.

## License

This configuration is open-source and available under the MIT License.
