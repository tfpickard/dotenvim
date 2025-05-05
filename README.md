# 💤 LazyVim Configuration

This repository contains a customized Neovim configuration based on [LazyVim](https://github.com/LazyVim/LazyVim). It is designed to enhance your development experience with a focus on performance, ease of use, and extensibility.

## Features

- **Lazy Loading**: Only loads plugins when necessary to improve startup time.
- **LSP Support**: Integrated with `nvim-lspconfig` and `typescript.nvim` for enhanced language support.
- **Treesitter Integration**: Syntax highlighting and code navigation using `nvim-treesitter`.
- **Code Formatting**: Auto-formatting with `stylua` and other tools.
- **Git Integration**: Use `lazygit` for seamless Git operations.
- **Custom Keymaps**: Enhanced navigation and editing with intuitive keybindings.
- **Snacks.nvim**: Provides additional UI enhancements and animations.

## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/your-repo.git ~/.config/nvim
   ```

2. **Install Dependencies**:
   Ensure you have the following installed:
   - Neovim (>= 0.10.0)
   - Node.js (for LSP servers)
   - `ripgrep` (for searching)
   - `lazygit` (optional, for Git integration)

3. **Install Plugins**:
   Open Neovim and run:
   ```vim
   :Lazy
   ```

## Key Bindings

- **File Operations**:
  - `<leader>ff`: Find files using Telescope.
  - `<leader>fp`: Find plugin files.

- **Buffer Management**:
  - `<S-h>` / `<S-l>`: Navigate between buffers.
  - `<leader>bd`: Delete current buffer.

- **Window Management**:
  - `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`: Navigate between windows.
  - `<leader>-` / `<leader>|`: Split windows.

- **Git Operations**:
  - `<leader>gg`: Open Lazygit in the root directory.
  - `<leader>gb`: Git blame for the current line.

- **LSP and Diagnostics**:
  - `<leader>cd`: Show line diagnostics.
  - `]d` / `[d`: Navigate diagnostics.

## Customization

- **Plugins**: Add or remove plugins in `lua/plugins/`.
- **Keymaps**: Customize keymaps in `lua/config/keymaps.lua`.
- **Options**: Modify settings in `lua/config/options.lua`.

## Contributing

Feel free to open issues or submit pull requests for improvements or bug fixes.

## License

This configuration is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Acknowledgments

- [LazyVim](https://github.com/LazyVim/LazyVim) for the base configuration.
- All plugin authors for their amazing work.
