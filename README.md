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

- **hrsh7th/nvim-cmp**: Completion plugin for Neovim.
- **saghen/blink.cmp**: Provides advanced completion features and snippet expansion.
- **Civitasv/cmake-tools.nvim**: Tools for working with CMake in Neovim.
- **neovim/nvim-lspconfig**: Quickstart configurations for the Neovim LSP client.
- **stevearc/conform.nvim**: A plugin for code formatting.
- **MeanderingProgrammer/render-markdown.nvim**: Renders markdown files in Neovim.
- **linux-cultist/venv-selector.nvim**: Simplifies Python virtual environment management.
- **jay-babu/mason-nvim-dap.nvim**: Configures debugging adapters for Python.
- **t3ntxcl3s/ecolog.nvim**: Manages environment variables with key mappings for quick access.
- **sos**: Provides autosave functionality with pre and post save hooks.
- **undo-glow**: Highlights text when yanking or gaining focus.
- **LazyVim**: A collection of plugins and configurations for Neovim.

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
