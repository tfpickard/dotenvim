# Neovim Plugin Audit

Date: 2026-03-25

## Snapshot

- Active plugins: `84`
- Imported LazyVim extras: `34`
- Installed plugin directories under `~/.local/share/nvim/lazy`: `99`
- Stale/inactive installed plugin directories: `15`
- Plugin source footprint: `~759M`
- Mason footprint: `~536M`
- Stale/inactive plugin footprint alone: `~350.8M`
- Measured startup to `--- NVIM STARTED ---`: `~72.98ms`
- Eager-loaded plugins: `LazyVim`, `snacks.nvim`, `oil.nvim`, `ecolog.nvim`, `nvim-puppeteer`

## Highest-Confidence Recommendations

1. Clean the `15` stale/inactive plugin directories with `:Lazy clean`.
   Biggest dead disk users are `letterspread.nvim` (`179M`), `pineapple` (`106M`), `avante.nvim` (`52M`), `fzf-lua` (`4.6M`), and `remote-sshfs.nvim` (`4.4M`).

2. Collapse the picker stack.
   [`lazyvim.json`](lazyvim.json) enables `editor.fzf`, `editor.snacks_picker`, and `editor.telescope`, but your live `<leader>ff`, `<leader>/`, `<leader>sg`, and `<leader>e` routes already go through Snacks. `telescope.nvim` is the easiest cut unless you depend on Telescope-specific extensions. If you want a dedicated best-in-class picker outside Snacks, `fzf-lua` is the stronger candidate to revive.

3. Pick one file explorer as the default.
   [`lua/plugins/oil.lua`](lua/plugins/oil.lua) configures `oil.nvim` as the default directory explorer, but your live `<leader>e` mapping goes to Snacks Explorer. Keeping both is reasonable only if you intentionally use both modes: Oil for "edit the filesystem like a buffer", Snacks for quick tree/picker navigation.

4. Remove the duplicate Copilot bridge.
   Your local [`lua/plugins/copilot.lua`](lua/plugins/copilot.lua) adds `giuxtaposition/blink-cmp-copilot`, while current LazyVim already wires `fang2hou/blink-copilot` in its Copilot extra. You only need one Blink Copilot source.

5. Drop `vgit.nvim`.
   `gitsigns.nvim` already covers signs/blame/hunks for day-to-day work, and your Git workflow is also exposed through GitUi/Snacks. `vgit.nvim` is an extra visual Git surface with very little unique value in this setup.

6. Replace `cmdline.nvim`, or remove it entirely.
   If you want command-line completion, Blink already supports it. If you want a full cmdline/message UI replacement, `noice.nvim` is the modern option, but you currently have it explicitly disabled. The current `cmdline.nvim` is small and clever, but niche.

7. Drop or remap `sshiv.nvim`.
   Many of its advertised `<leader>s*` mappings are shadowed live by Snacks and Aerial. In practice, `sshiv.nvim` is only partially reachable unless you use its commands directly.

8. Drop `surround-ui.nvim`.
   It is explicitly a training aid for `nvim-surround`, and your configured `root_key = "S"` collides with live `Flash Treesitter` on `S`.

9. Drop `lightswitch.nvim`, `hawtkeys.nvim`, `nerdy.nvim`, and `store.nvim` unless you use them weekly.
   Snacks already gives you toggles, icon search, keymap search, notification history, Git utilities, and a large utility surface. These plugins mostly add more surface area than capability now.

10. Remove the dead `nvim-cmp` extra.
    [`lazyvim.json`](lazyvim.json) still imports `lazyvim.plugins.extras.coding.nvim-cmp`, but [`lua/plugins/blink.lua`](lua/plugins/blink.lua) disables `hrsh7th/nvim-cmp`.

## Config-Level Redundancies And Live Collisions

- Picker overlap:
  [`lazyvim.json`](lazyvim.json) enables `editor.fzf`, `editor.snacks_picker`, and `editor.telescope`.
- Explorer overlap:
  [`lua/plugins/oil.lua`](lua/plugins/oil.lua) sets `oil.nvim` as a default explorer, while live `<leader>e` resolves to Snacks Explorer.
- Copilot source duplication:
  [`lua/plugins/copilot.lua`](lua/plugins/copilot.lua) adds `blink-cmp-copilot`, while LazyVim's Copilot extra already adds `blink-copilot`.
- `sshiv.nvim` key collisions:
  [`lua/plugins/sshiv.lua`](lua/plugins/sshiv.lua) claims `<leader>ss`, `<leader>sl`, `<leader>sp`, `<leader>sb`, `<leader>sk`, and `<leader>si`, but live mappings resolve to Aerial or Snacks for most of those keys.
- `surround-ui.nvim` key collision:
  [`lua/plugins/surround.lua`](lua/plugins/surround.lua) sets `root_key = "S"`, but live `S` resolves to Flash Treesitter.

## Plugin Matrix

### Pickers, Search, Navigation

| Plugin | Why it's here | Overlap / modern alternative | Label |
|---|---|---|---|
| `snacks.nvim` | Primary picker/explorer/notifier/utility surface | Keep as the core QoL layer. It already owns most search mappings. | `keep` |
| `telescope.nvim` | Legacy/general fuzzy finder | Redundant with active Snacks picker. If you want a dedicated external picker, prefer `fzf-lua`; otherwise remove. | `drop` |
| `grug-far.nvim` | Project-wide search/replace | Still strong and distinct from Snacks/Telescope pickers. | `keep` |
| `aerial.nvim` | Symbols/code outline | Good if you use outline navigation; otherwise optional. | `keep if used` |
| `harpoon` | Fast file mark/jump workflow | Still useful and distinct. | `keep if used` |
| `project.nvim` | Project root/history support | Reasonable, but partly overlaps with Snacks projects. Keep if you rely on project history. | `keep if used` |
| `hawtkeys.nvim` | Keymap ergonomics audit | Snacks already exposes keymap discovery on `<leader>sk`; this is more analysis than workflow. | `drop` |
| `nerdy.nvim` | Icon search/picker | Snacks already exposes icon search on `<leader>si`. | `drop` |
| `store.nvim` | Plugin-store UI inside Neovim | `lazy.nvim` and the web already cover plugin management/discovery better. | `drop` |
| `todo-comments.nvim` | Search/highlight TODOs | Useful but optional; easy to remove if you never act on TODO lists. | `keep if used` |

### Explorers, Files, Projects

| Plugin | Why it's here | Overlap / modern alternative | Label |
|---|---|---|---|
| `oil.nvim` | Buffer-style filesystem editing | Still one of the best options if you actually want editable filesystem buffers. Keep only if you use that mode deliberately. | `keep if used` |
| `snacks.nvim` explorer | Fast project/file explorer | Already owns your main explorer mapping. Good default if you want one explorer only. | `keep` |
| `chezmoi.nvim` | Chezmoi integration | Keep only if you actually manage dotfiles with Chezmoi. | `keep if used` |
| `chezmoi.vim` | Companion Chezmoi integration | Same as above. | `keep if used` |
| `nvim-puppeteer` | Browser automation helper | Unique, but niche and eager-loaded. Keep only if it is a real workflow. | `keep if used` |
| `sshiv.nvim` | Remote command execution over SSH | Interesting custom workflow, but most normal-mode mappings are shadowed. Keep only if you use `:Sshiv*` commands or are willing to remap it. | `keep if used` |

### Git

| Plugin | Why it's here | Overlap / modern alternative | Label |
|---|---|---|---|
| `gitsigns.nvim` | Inline hunks/blame/signs | Core Git signal inside buffers. | `keep` |
| `vgit.nvim` | Visual Git UI | Overlaps heavily with `gitsigns.nvim` plus GitUi/Snacks Git surfaces. | `drop` |
| `trouble.nvim` | Diagnostics / lists UI | Still worthwhile if you use diagnostics and list views often. | `keep` |

### Completion, LSP, AI

| Plugin | Why it's here | Overlap / modern alternative | Label |
|---|---|---|---|
| `blink.cmp` | Primary completion engine | This is the modern completion core here. | `keep` |
| `blink-copilot` | LazyVim's current Copilot source for Blink | Keep this if you keep Copilot completions. | `keep` |
| `blink-cmp-copilot` | Extra Copilot source added locally | Duplicates the role of `blink-copilot` in current LazyVim. Remove this one. | `replace` |
| `copilot.lua` | Inline Copilot suggestions | Reasonable to keep if you actually use Copilot. | `keep if used` |
| `CopilotChat.nvim` | Chat/code assistant UI | Good if you use conversational Copilot workflows. | `keep if used` |
| `conform.nvim` | Formatting | Keep. | `keep` |
| `nvim-lint` | Linting | Keep if you still want separate lint sources beyond LSP. | `keep if used` |
| `nvim-lspconfig` | LSP setup | Keep. | `keep` |
| `mason.nvim` | External tool installer | Keep. The size is large, but it is functional bloat, not dead bloat. | `keep` |
| `mason-lspconfig.nvim` | Mason/LSP bridge | Keep. | `keep` |
| `mason-tool-installer.nvim` | Ensure tool install set | Keep if you like declarative tool bootstrapping. | `keep` |
| `lazydev.nvim` | Lua dev completion/docs | Keep. | `keep` |
| `SchemaStore.nvim` | YAML/JSON schemas | Keep. | `keep` |
| `LuaSnip` | Snippet engine | Keep if you use snippets. If not, Blink can work with lighter snippet setups later. | `keep if used` |
| `friendly-snippets` | Snippet collection | Keep if you keep `LuaSnip`. | `keep if used` |
| `nvim-treesitter` | Syntax/tree parsing | Keep. | `keep` |
| `nvim-treesitter-textobjects` | Treesitter textobjects | Keep if you actively use textobjects. | `keep if used` |
| `nvim-ts-autotag` | HTML/JSX tag autoclose/rename | Keep if you edit markup regularly. | `keep if used` |
| `venv-selector.nvim` | Python venv switching | Keep if you do frequent Python work from Neovim. | `keep if used` |
| `clangd_extensions.nvim` | Better C/C++ UX | Keep if you actively do C/C++. | `keep if used` |
| `cmake-tools.nvim` | CMake integration | Keep if you actively do CMake work. | `keep if used` |

### UI, Notifications, Commandline, Status

| Plugin | Why it's here | Overlap / modern alternative | Label |
|---|---|---|---|
| `lualine.nvim` | Statusline | Keep. | `keep` |
| `which-key.nvim` | Key discovery | Keep. | `keep` |
| `bufferline.nvim` | Buffer tabline | Optional quality-of-life only. | `keep if used` |
| `alpha-nvim` | Startup dashboard | Fine if you like dashboards. If you want one suite, Snacks dashboard is the integrated alternative. | `keep if used` |
| `edgy.nvim` | Side-panel layout manager | Keep if you like the layout; otherwise it is easy UI surface to cut. | `keep if used` |
| `cmdline.nvim` | Helix-style wildmenu replacement | Replace with Blink cmdline or native cmdline. Use Noice only if you want a full UI replacement. | `replace` |
| `focus.nvim` | Auto-resizing splits | Nice but optional; not clearly better than just living with normal splits. | `keep if used` |
| `smartcolumn.nvim` | Dynamic color column | Optional. Built-in `colorcolumn` is enough for many people. | `keep if used` |
| `nvim-colorizer.lua` | Color previews in buffers | Keep if you edit CSS/Tailwind/colors regularly. | `keep if used` |
| `vim-startuptime` | Startup profiling command | Useful only when profiling. `snacks.profiler` exists if you want to keep everything in one suite. | `drop` |
| `catppuccin` | Theme integration support | Drop unless you actually switch to it. Right now `tokyonight` is the active theme. | `drop` |
| `tokyonight.nvim` | Active theme | Keep. | `keep` |
| `nvim-web-devicons` | Icons dependency | Keep unless you aggressively standardize everything on `mini.icons` and remove consumers. | `keep` |
| `mini.icons` | Icons dependency | Keep. `oil.nvim` already depends on it. | `keep` |
| `nui.nvim` | UI dependency | Keep. Multiple plugins depend on it. | `keep` |
| `plenary.nvim` | Utility dependency | Keep. Multiple plugins depend on it. | `keep` |

### Editing Helpers And Motion

| Plugin | Why it's here | Overlap / modern alternative | Label |
|---|---|---|---|
| `flash.nvim` | Fast jump/motion UX | Keep. | `keep` |
| `better-escape.nvim` | `jk`/`jj` escape | Fine if it matches muscle memory. | `keep if used` |
| `dial.nvim` | Increment/decrement variants | Useful but optional. | `keep if used` |
| `nvim-surround` | Surround operations | Keep. | `keep` |
| `surround-ui.nvim` | Training/helper layer for `nvim-surround` | Explicitly a training aid, and your `S` key collides with Flash. | `drop` |
| `comment-box.nvim` | Decorative comment boxes | Useful only if you write a lot of structured headers/comments. | `keep if used` |
| `sort.nvim` | Sort text objects/lines | Useful if you actually hit `go`; otherwise easy cut. | `keep if used` |
| `split.nvim` | Split long delimiter-separated lines | Unique and fairly modern; keep if you actually use it. | `keep if used` |
| `yanky.nvim` | Better yank/paste history | Still good. | `keep if used` |
| `undo-glow.nvim` | Visual feedback for undo/yank/search/comment | Clever, but it remaps core keys like `u`, `p`, `n`, `gc`, and `gcc`; keep only if you truly like the effect. | `keep if used` |
| `visual-whitespace.nvim` | Show whitespace during visual mode | Nice but optional. | `keep if used` |
| `nvim-regexplainer` | Explain regexes | Keep if you work with regex enough to need it. | `keep if used` |
| `mini.ai` | Additional textobjects | Keep. | `keep` |
| `mini.pairs` | Autopairs | Keep if you want autopairs. | `keep if used` |
| `vim-illuminate` | Reference highlighting/jumps | Redundant with `snacks.words`, which is already enabled. | `replace` |
| `lightswitch.nvim` | Toggle Copilot/LSP/Treesitter/diagnostics/formatting | Snacks already has integrated toggle support; this is duplicate surface. | `drop` |
| `cellular-automaton.nvim` | Fun/novelty animations | Pure novelty. | `drop` |
| `illogical.nvim` | Custom personal plugin | Keep only if you actually use its behavior. No obvious mainstream replacement. | `keep if used` |

### Language / Markdown / Environment Workflow

| Plugin | Why it's here | Overlap / modern alternative | Label |
|---|---|---|---|
| `ecolog.nvim` | `.env` navigation and interpolation workflow | Unique and integrated with Snacks/Blink. Keep if you use env-heavy projects. | `keep if used` |
| `render-markdown.nvim` | In-buffer Markdown rendering | Good default Markdown renderer. | `keep if used` |
| `markview.nvim` | Alternate Markdown rendering / Store preview helper | Overlaps with `render-markdown.nvim`; easiest cut if you also drop `store.nvim`. | `drop` |
| `markdown-preview.nvim` | Browser-based Markdown preview | Keep only if you need browser-accurate previewing. | `keep if used` |
| `mini.hipatterns` | Pattern highlighting | Keep if you like the lightweight highlighting extras. | `keep if used` |

### Core Runtime And Session Plumbing

| Plugin | Why it's here | Overlap / modern alternative | Label |
|---|---|---|---|
| `LazyVim` | Distro base | Keep. | `keep` |
| `lazy.nvim` | Plugin manager | Keep. | `keep` |
| `persistence.nvim` | Session restore | Keep if you use sessions. | `keep if used` |
| `ts-comments.nvim` | Treesitter-aware comments | Keep. | `keep` |

## Disabled Specs In Repo

These are still present in your config tree, but not active in the current runtime snapshot.

| Plugin | Current state | Recommendation | Label |
|---|---|---|---|
| `noice.nvim` | Explicitly disabled in `lua/plugins/disabled.lua` | Leave disabled unless you specifically want a full UI replacement for messages/cmdline/popupmenu. | `already dead/stale` |
| `hardtime.nvim` | Spec present but disabled | Good to keep disabled unless you want intentional movement training. | `already dead/stale` |
| `nvim-dev-container` | Spec present but disabled | Keep disabled unless devcontainers are a real workflow. | `already dead/stale` |
| `stopinsert.nvim` | Spec present but disabled | Remove unless you plan to re-enable it soon. | `already dead/stale` |
| `spaceport.nvim` | Spec present but disabled | Remove unless you plan to revive it. | `already dead/stale` |
| `remote-sshfs.nvim` | Spec present but disabled, still installed on disk | Remove spec and clean install if not reviving. | `already dead/stale` |
| `letterspread.nvim` | Spec present but disabled, still installed on disk | Remove spec and clean install unless this is an active side project. | `already dead/stale` |
| `nvim-comment-frame` | Disabled inside `lua/plugins/comments.lua` | Remove. `comment-box.nvim` already covers the decorative-comment niche better. | `already dead/stale` |
| `nvim-cmp` | Extra still imported, but disabled by `lua/plugins/blink.lua` | Remove the extra import from `lazyvim.json`. | `already dead/stale` |

## Stale/Inactive Installed Plugin Directories

These are installed under `~/.local/share/nvim/lazy`, but not in the active runtime plugin set.

| Plugin dir | Notes | Recommendation | Label |
|---|---|---|---|
| `aider.nvim` | Old AI experiment | Clean unless you plan to revive it. | `already dead/stale` |
| `automkdir.nvim` | Old utility | Clean. | `already dead/stale` |
| `avante.nvim` | Removed AI stack, still large on disk (`52M`) | Clean. | `already dead/stale` |
| `dressing.nvim` | Old dependency, no longer active | Clean. | `already dead/stale` |
| `fzf-lua` | Not active, but the best candidate if you want a fast dedicated picker | Either clean it or explicitly switch to it as your Telescope replacement. | `already dead/stale` |
| `gruvbox` | Old colorscheme | Clean unless you still switch to it. | `already dead/stale` |
| `gruvbox.nvim` | Old colorscheme | Clean unless you still switch to it. | `already dead/stale` |
| `img-clip.nvim` | Old media helper | Clean unless you revive the workflow. | `already dead/stale` |
| `letterspread.nvim` | Disabled spec, still huge on disk (`179M`) | Clean. | `already dead/stale` |
| `mini.pick` | Old picker backend | Clean if you stay on Snacks. | `already dead/stale` |
| `pineapple` | Removed colorscheme, still huge on disk (`106M`) | Clean. | `already dead/stale` |
| `remote-sshfs.nvim` | Disabled spec, still installed (`4.4M`) | Clean. | `already dead/stale` |
| `sleezwave.nvim` | Old colorscheme/theme experiment | Clean. | `already dead/stale` |
| `themify.nvim` | Old theme manager | Clean. | `already dead/stale` |
| `typescript.nvim` | Old TS helper stack | Clean. | `already dead/stale` |

## Bloat Estimate

### Real Disk Bloat

- `~350.8M` is reclaimable immediately from stale/inactive plugin directories.
- The biggest dead weight is not functionality, it is old plugin directories that were never cleaned after you deleted specs.

### Startup Bloat

- Startup is not currently terrible at `~72.98ms`.
- Only five plugins are eager-loaded: `LazyVim`, `snacks.nvim`, `oil.nvim`, `ecolog.nvim`, and `nvim-puppeteer`.
- The bigger issue is not startup latency; it is that several overlapping plugin stacks still exist in config and on disk.

### Active Overlap Bloat

- Pickers: `snacks.picker` vs `telescope.nvim`, plus stale `fzf-lua`
- Explorers: `oil.nvim` vs `snacks.explorer`
- Git: `gitsigns.nvim` vs `vgit.nvim`, plus GitUi/Snacks utilities
- Copilot completion: `blink-copilot` vs `blink-cmp-copilot`
- Markdown: `render-markdown.nvim` vs `markview.nvim` vs `markdown-preview.nvim`
- References/jumps: `vim-illuminate` vs `snacks.words`
- Small utility surface: `lightswitch.nvim`, `hawtkeys.nvim`, `nerdy.nvim`, `store.nvim`

### Cognitive / Maintenance Bloat

- `lazyvim.json` still imports extras for stacks you already replaced or partially disabled.
- Some plugin mappings are shadowed live, which means parts of the config are dead without looking dead.
- The repo contains disabled specs and deleted experiments that still influence how hard it is to reason about the setup.

## Suggested Removal Order

1. Clean stale installed dirs with `:Lazy clean`.
2. Remove `lazyvim.plugins.extras.coding.nvim-cmp` from `lazyvim.json`.
3. Remove `telescope.nvim` unless you depend on Telescope-only extensions.
4. Remove local `blink-cmp-copilot` and keep LazyVim's `blink-copilot`.
5. Remove `vgit.nvim`.
6. Remove `surround-ui.nvim`.
7. Remove `lightswitch.nvim`, `hawtkeys.nvim`, `nerdy.nvim`, and `store.nvim` if you are not using them weekly.
8. Decide between `oil.nvim` and Snacks Explorer as the one true default.
9. Either remap `sshiv.nvim` or remove it.
10. Trim markdown surface by choosing between `render-markdown.nvim` and `markview.nvim`, then keeping `markdown-preview.nvim` only if you truly need browser preview.

## Validation Checklist If You Later Apply The Cleanup

- `:Lazy`
- `:checkhealth`
- `:checkhealth snacks`
- `:checkhealth telescope` only if Telescope stays
- Verify `<leader>ff`, `<leader>/`, `<leader>sg`, `<leader>e`
- Verify Git flow: signs, status, browse/open, GitUi
- Verify Copilot inline suggestions and CopilotChat
- Verify Ecolog commands if you keep `ecolog.nvim`
- Verify SSH workflow if you keep `sshiv.nvim`
- Verify there are no broken `noice`, `snacks`, or `dap` statusline references
- Re-run startup timing after cleanup
- Re-run `:Lazy clean` after plugin removals

## Sources

- Official Snacks repo: <https://github.com/folke/snacks.nvim>
- Official Oil repo: <https://github.com/stevearc/oil.nvim>
- Official Blink repo: <https://github.com/saghen/blink.cmp>
- Official Telescope repo: <https://github.com/nvim-telescope/telescope.nvim>
- Official fzf-lua repo: <https://github.com/ibhagwan/fzf-lua>
- Official cmdline.nvim repo: <https://github.com/vzze/cmdline.nvim>
- Official Noice repo: <https://github.com/folke/noice.nvim>
- Official surround-ui repo: <https://github.com/roobert/surround-ui.nvim>
- Official vgit repo: <https://github.com/tanvirtin/vgit.nvim>
