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

- **lazyvim.plugins.extras.ai.copilot**
- **lazyvim.plugins.extras.ai.copilot-chat**
- **lazyvim.plugins.extras.coding.blink**
- **lazyvim.plugins.extras.coding.luasnip**
- **lazyvim.plugins.extras.coding.nvim-cmp**
- **lazyvim.plugins.extras.coding.yanky**
- **lazyvim.plugins.extras.editor.aerial**
- **lazyvim.plugins.extras.editor.dial**
- **lazyvim.plugins.extras.editor.fzf**
- **lazyvim.plugins.extras.editor.harpoon2**
- **lazyvim.plugins.extras.editor.illuminate**
- **lazyvim.plugins.extras.editor.inc-rename**
- **lazyvim.plugins.extras.editor.snacks_picker**
- **lazyvim.plugins.extras.editor.telescope**
- **lazyvim.plugins.extras.formatting.biome**
- **lazyvim.plugins.extras.formatting.black**
- **lazyvim.plugins.extras.formatting.prettier**
- **lazyvim.plugins.extras.lang.clangd**
- **lazyvim.plugins.extras.lang.cmake**
- **lazyvim.plugins.extras.lang.docker**
- **lazyvim.plugins.extras.lang.git**
- **lazyvim.plugins.extras.lang.json**
- **lazyvim.plugins.extras.lang.markdown**
- **lazyvim.plugins.extras.lang.python**
- **lazyvim.plugins.extras.lang.toml**
- **lazyvim.plugins.extras.lang.yaml**
- **lazyvim.plugins.extras.ui.alpha**
- **lazyvim.plugins.extras.ui.edgy**
- **lazyvim.plugins.extras.util.chezmoi**
- **lazyvim.plugins.extras.util.dot**
- **lazyvim.plugins.extras.util.gitui**
- **lazyvim.plugins.extras.util.mini-hipatterns**
- **lazyvim.plugins.extras.util.project**
- **lazyvim.plugins.extras.util.startuptime**

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
