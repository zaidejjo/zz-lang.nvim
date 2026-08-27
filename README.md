# zz-lang.nvim

All-in-one Neovim plugin for the [ZZ programming language](https://github.com/zaidejjo/zz_lang).

Zero external plugin dependencies.  Uses Neovim's built-in LSP client (`vim.lsp.start()`).

## Features

| Feature | Description |
|---|---|
| **LSP** | Full language server integration via `zz-lsp` |
| **Completion** | Context-aware autocompletion (variables, functions, fields) |
| **Hover** | Type information and documentation on `K` |
| **Go-to-definition** | Navigate to symbols with `gd` |
| **Find references** | Find all usages with `gr` |
| **Rename** | Rename symbols across files with `<leader>rn` |
| **Code actions** | Quick fixes for diagnostics with `<leader>ca` |
| **Formatting** | Format-on-save + `:ZZFmt` command |
| **Inlay hints** | Parameter names at call sites |
| **Semantic tokens** | AST-based syntax highlighting from the LSP |
| **Folding ranges** | Collapse functions, structs, loops |
| **Diagnostics** | Real-time errors and warnings |
| **Syntax highlighting** | Vim syntax for all ZZ keywords, types, operators |
| **Snippets** | Code snippets for common ZZ constructs |
| **Statusline** | Lualine component showing LSP status |
| **CLI commands** | `:ZZRun`, `:ZZCheck`, `:ZZFmt` |

## Requirements

- **Neovim** >= 0.8 (for `vim.lsp.start()`)
- **zz-lsp** binary in your `$PATH`

Install `zz-lsp` from the [ZZ repository](https://github.com/zaidejjo/zz_lang):

```bash
cargo build --release -p zz_lsp
# Copy target/release/zz-lsp to a directory in your PATH
sudo cp target/release/zz-lsp /usr/local/bin/
```

## Installation

### lazy.nvim (recommended)

```lua
{
  "zaidejjo/zz-lang.nvim",
  ft = "zz",
  config = function()
    require("zz-lang").setup({
      -- your config overrides here (optional)
    })
  end,
}
```

### packer.nvim

```lua
use {
  "zaidejjo/zz-lang.nvim",
  ft = "zz",
  config = function()
    require("zz-lang").setup()
  end,
}
```

### vim-plug

```vim
Plug 'zaidejjo/zz-lang.nvim'

autocmd FileType zz lua require("zz-lang").setup()
```

### Manual

Clone into your Neovim plugin directory:

```bash
git clone https://github.com/zaidejjo/zz-lang.nvim \
  ~/.local/share/nvim/site/pack/plugins/start/zz-lang.nvim
```

Then add to your `init.lua`:

```lua
require("zz-lang").setup()
```

## Configuration

All options with their defaults:

```lua
require("zz-lang").setup({
  -- LSP server configuration
  lsp = {
    enabled = true,                -- start zz-lsp automatically
    cmd = { "zz-lsp" },           -- command to start the server
    root_markers = { ".git", "*.zz" },  -- project root detection
    capabilities = nil,            -- override LSP capabilities
    on_attach = nil,               -- callback: function(client, bufnr)
  },

  -- Formatting
  format = {
    on_save = true,                -- format .zz files on write
    uses_lsp = true,               -- use LSP formatting; falls back to `zz fmt`
  },

  -- User commands
  commands = {
    ZZRun = true,                  -- :ZZRun  — run current file
    ZZCheck = true,                -- :ZZCheck — type-check current file
    ZZFmt = true,                  -- :ZZFmt — format current file
  },

  -- Snippets
  snippets = {
    enabled = true,                -- register ZZ snippet triggers
  },

  -- Statusline integration
  statusline = {
    enabled = false,               -- opt-in lualine component
  },
})
```

## Keymaps

Default keymaps (set when a `.zz` file is opened):

| Key | Mode | Action |
|---|---|---|
| `gd` | n | Go to definition |
| `gD` | n | Go to declaration |
| `gr` | n | Find references |
| `gi` | n | Go to implementation |
| `K` | n | Hover documentation |
| `<C-k>` | n, i | Signature help |
| `<leader>rn` | n | Rename symbol |
| `<leader>ca` | n | Code action |
| `<leader>f` | n | Format buffer |

Override any keymap in your `on_attach`:

```lua
require("zz-lang").setup({
  lsp = {
    on_attach = function(client, bufnr)
      -- Your custom keymaps here
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
    end,
  },
})
```

## Commands

| Command | Description |
|---|---|
| `:ZZRun` | Run the current file (`zz run <file>`) in a terminal split |
| `:ZZCheck` | Type-check the current file (`zz check <file>`) |
| `:ZZFmt` | Format the current file (via LSP or `zz fmt`) |
| `:ZZDiag` | Show diagnostics at the cursor line |

## Formatting

Format-on-save is enabled by default.  The plugin first tries LSP
formatting (`textDocument/formatting`), then falls back to shelling
out to `zz fmt`.

Disable format-on-save:

```lua
require("zz-lang").setup({
  format = { on_save = false },
})
```

Use `zz fmt` directly (bypass LSP):

```lua
require("zz-lang").setup({
  format = { uses_lsp = false },
})
```

## Snippets

Available snippet triggers (use Tab or your snippet engine):

| Trigger | Expansion |
|---|---|
| `func` | `func name(params) -> ret { body }` |
| `funcnr` | `func name(params) { body }` (no return) |
| `struct` | `struct Name { field: type }` |
| `if` | `if condition { body }` |
| `ife` | `if condition { } else { }` |
| `iflet` | `if let .some(x) = value { } else { }` |
| `for` | `for item in iterable { body }` |
| `forr` | `for i in 0..n { body }` |
| `while` | `while condition { body }` |
| `match` | `match expr { .variant(v) => body }` |
| `import` | `import std.module` |
| `defer` | `defer expr` |
| `ret` | `return expr` |
| `\|` | `\|args\| expr` (closure) |
| `dict` | `{ key: value }` |

Snippets work automatically with [luasnip](https://github.com/L3MON4D3/LuaSnip)
if installed.  Otherwise, a basic keymap fallback is provided.

## Statusline

The plugin includes an opt-in statusline component.  Enable it:

```lua
require("zz-lang").setup({ statusline = { enabled = true } })
```

### lualine.nvim integration

```lua
require("lualine").setup({
  sections = {
    lualine_x = { require("zz-lang.statusline").lualine_component() },
  },
})
```

The component shows:
- `ZZ` when the language server is connected
- `ZZ(-)` when disconnected
- `E:3 W:1` with error/warning counts
- Color turns red on errors

## How It Works

This plugin uses Neovim's built-in LSP client (`vim.lsp.start()`) to
communicate with `zz-lsp`.  No `nvim-lspconfig` or other plugin
dependencies are required.

The plugin handles:
1. **Filetype detection** — `*.zz` files are detected automatically
2. **Syntax highlighting** — Vim regex-based highlighting for all ZZ constructs
3. **LSP client** — Auto-starts and attaches `zz-lsp` to `.zz` buffers
4. **Keymaps** — Standard LSP keymaps (gd, gr, K, etc.)
5. **Formatting** — Format-on-save via LSP or `zz fmt`
6. **Commands** — `:ZZRun`, `:ZZCheck`, `:ZZFmt`

## Troubleshooting

### LSP not starting

Make sure `zz-lsp` is in your `$PATH`:

```bash
which zz-lsp
```

### Debug logging

Set the `RUST_LOG` environment variable before starting Neovim:

```bash
RUST_LOG=debug nvim
```

Or in your shell config:

```lua
-- In init.lua, before require("zz-lang").setup():
vim.env.RUST_LOG = "zz_lsp=debug"
```

### Check LSP status

```lua
:lua print(vim.inspect(vim.lsp.get_clients({ name = "zz-lsp" })))
```

## License

MIT
