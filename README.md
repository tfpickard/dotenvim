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

## Key Plugins

- **sos**: Provides autosave functionality with pre and post save hooks.
- **blink.cmp**: Offers advanced completion features and snippet expansion.
- **codecompanion**: Integrates AI-powered code suggestions.
- **ecolog.nvim**: Manages environment variables with key mappings for quick access.
- **venv-selector.nvim**: Simplifies Python virtual environment management.
- **mason-nvim-dap**: Configures debugging adapters for Python.

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
