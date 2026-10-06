# nvim-zz

Neovim plugin for [ZZ](https://github.com/zz-language/zz). Zero dependencies — uses the built-in LSP client. Docs: <https://zz-lang.pages.dev>.

## Requirements

Neovim >= 0.8, plus the `zz` CLI and `zz-lsp` binary in `$PATH`:

```bash
cargo install --path crates/zz_cli
cargo build --release -p zz_lsp && sudo cp target/release/zz-lsp /usr/local/bin/
```

## Install

```lua
-- lazy.nvim
{ "zz-language/nvim-zz", ft = "zz", config = function() require("zz-lang").setup() end }
```

No plugin manager? Clone to `~/.local/share/nvim/site/pack/plugins/start/nvim-zz` and call `require("zz-lang").setup()`.

## Configure

Everything works out of the box. Override only what you need:

```lua
require("zz-lang").setup({
  format = { on_save = false },          -- default: format on save
  lsp = { cmd = { "zz-lsp" } },          -- default server command
})
```

Run `:checkhealth nvim-zz` to verify your setup.

## Copy-paste setup

**Lazy plugin file** (`~/.config/nvim/lua/plugins/zz.lua`):

```lua
return {
  "zz-language/nvim-zz",
  ft = "zz",
  config = function()
    require("zz-lang").setup()
  end,
}
```

**Directly in `init.lua`:**

```lua
-- with lazy.nvim loaded plugin, or manual install:
require("zz-lang").setup({
  -- format = { on_save = false },
  -- lsp = { cmd = { "zz-lsp" } },
})
```

## Keys

| Key | Action |
|---|---|
| `gd` / `gr` / `K` | Definition / references / hover (`K` falls back to stdlib docs) |
| `<leader>rn` / `<leader>ca` | Rename / code action |
| `<leader>f` | Format buffer |
| `]d` / `[d` | Next / previous diagnostic |

## Commands

`:ZZRun` `:ZZCheck` `:ZZFmt` `:ZZTest` `:ZZBuild` — act on the current file. `:ZZDoc` shows stdlib help for the word under the cursor. `:ZZDiag` shows line diagnostics.

Snippets (`func`, `match`, `httproute`, …) register with luasnip/cmp automatically, omnifunc otherwise. `gf` follows `import`s.

## License

MIT
