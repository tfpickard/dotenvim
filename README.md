# Neovim Configuration

A [LazyVim](https://www.lazyvim.org/)-based Neovim config, tuned for Python,
TypeScript, Go, Rust, C/C++ and shell work.

Requires **Neovim ≥ 0.11** (developed against 0.12-dev; the config uses the
native `vim.lsp.config` / `vim.diagnostic.jump` APIs).

## Design rules

Two conventions keep this config from rotting, both learned the hard way:

1. **Don't restate LazyVim's defaults as live code.** User config loads *after*
   LazyVim, so a copied default silently overrides upstream — including
   upstream's bug fixes. `lua/config/options.lua` and `lua/config/keymaps.lua`
   therefore contain only genuine deltas, with the full option surface kept
   nearby as commented reference so it's still discoverable.

2. **Every plugin spec needs a load trigger.** `lua/config/lazy.lua` sets
   `defaults = { lazy = true }`, so a spec with no `event`/`cmd`/`keys`/`ft` is
   resolved but *never loaded* — the plugin appears installed while doing
   nothing. Dependencies are the only exception; they load via `require`.

## Features

- **Completion** — `blink.cmp` (nvim-cmp disabled), with LSP, path, snippets,
  buffer, Copilot and a ripgrep source. `<CR>` accepts, `<C-y>` force-accepts.
- **AI** — GitHub Copilot surfaced through `blink.cmp` (`<Tab>` to accept), plus
  `sidekick.nvim` for Copilot **Next Edit Suggestions**: it predicts your next
  *edit* anywhere in the file, not just text after the cursor. `<Tab>` in normal
  mode jumps to a suggestion, `<Tab>` again applies it.
- **AI CLI** — `<leader>aa` opens an AI CLI in a split that shares buffer
  context. See the provider policy below.
- **LSP** — mason-managed servers via LazyVim extras; `bashls`, `html`,
  `vtsls`, `pyright` configured locally.
- **Formatting** — `conform.nvim` on save, honouring each project's own
  indentation via `guess-indent` and any `.editorconfig`/formatter config.
- **Autosave** — `auto-save.nvim`, debounced; toggle with `<leader>uW`.
- **Git** — lazygit + Snacks pickers, `diffview.nvim` for diffs and file history.
- **Navigation** — Snacks picker, `oil.nvim` (`-` opens the parent directory as
  an editable buffer), harpoon, flash, aerial.

## AI provider policy

This config is used on both a work and a personal machine.

At work, GitHub Copilot must be the AI **provider**. That constrains the
*vendor*, not the model — Claude Opus 5, GPT-5.6 and the other flagship models
Copilot brokers are all still Copilot, so the `copilot` CLI is unrestricted.

What must not happen at work is talking to a vendor **directly**. Those CLIs
authenticate from an API key in the environment, so the key's presence is the
capability check:

| CLI | Requires | Absent ⇒ |
| --- | --- | --- |
| `copilot` | — | always available |
| `claude` | `ANTHROPIC_API_KEY` | hidden from the picker |
| `codex` | `OPENAI_API_KEY` | hidden from the picker |
| `opencode` | `OPENROUTER_API_KEY` | hidden from the picker |

The environment *is* the policy: there's no toggle to forget, so a work machine
is correct by default and a personal machine lights the extra tools up on its
own. `<leader>aP` reports the effective state. No API keys live in this repo.

## Key mappings

LazyVim's defaults all apply — see the reference block at the bottom of
`lua/config/keymaps.lua`, or just press `<leader>` and read the which-key popup.
Every custom prefix is registered with which-key, so nothing shows up unlabelled.

Additions and changes on top of LazyVim:

| Key | Action |
| --- | --- |
| `-` | Open parent directory (Oil) |
| `<leader>ii` | Icon picker |
| `<leader>kl` | Split line, second half above |
| `<leader>wq` / `<leader>q!` | Save and quit all / force quit all |
| `<C-q>` | Quit |
| `<leader>a…` | AI (sidekick): `aa` toggle CLI, `as` select, `aP` policy |
| `<leader>E…` | Environment variables (ecolog) |
| `<leader>H…` | HTTP requests (kulala) |
| `<leader>R…` | Remote execution (sshiv) |
| `<leader>c{b,t,l,m}` | Comment boxes |
| `<leader>g{d,D,h,H}` | Diffview open/close, file/repo history |
| `<leader>rx` | Explain regex |
| `<leader>u{W,N,x}` | Toggle autosave / Copilot NES / treesitter context |
| `gs`, `gss`, `gS`, `gSS` | Split by pattern / interactive |
| `go` | Sort |
| `jk`, `jj` | Escape (insert, cmdline, terminal, visual, select) |

> `<leader>E` rather than `<leader>e` for ecolog: `<leader>e` is LazyVim's
> Explorer, and sharing the prefix made Explorer wait `timeoutlen` on every
> press.

## Layout

```
init.lua                  bootstraps lua/config/lazy.lua
lazyvim.json              which LazyVim extras are enabled
lua/config/
  lazy.lua                lazy.nvim bootstrap + performance settings
  options.lua             option deltas + commented LazyVim reference
  keymaps.lua             custom maps + commented LazyVim reference
  autocmds.lua            cursor-crosshair highlight fallback
lua/plugins/              one spec (or group) per file
```

## Installation

```sh
git clone https://github.com/tfpickard/dotenvim ~/.config/nvim
nvim   # lazy.nvim bootstraps itself and installs everything on first launch
```

Then run `:checkhealth` and `:Lazy` to confirm. `:Mason` manages external
tools; only tools actually wired into `conform`/`nvim-lint` are auto-installed.

## License

MIT.
