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
  highlight = { semantic_tokens = true, references = true },
})
```

Run `:checkhealth nvim-zz` to verify your setup (it also warns when
`zz-lsp --version` disagrees with `zz --version` — reinstall both from
the same tree, then restart the editor).

## Autocomplete

Completion is served by `zz-lsp`: bare names, `math.`/`table.` members
with signatures, `std.` modules, `import std.…` paths, selective lists
(`import std.math(P…)`), and workspace/dependency members — including
`pub` globals, structs and generics. It works with zero extra plugins:

- `<C-Space>` (insert mode) or `C-x C-o` triggers it via omnifunc.
- With `nvim-cmp` or `blink.cmp` installed, their capabilities are
  merged automatically and completions appear as you type.
- Snippet triggers (`func`, `match`, …) complete through the same menu.

Optional `nvim-cmp` filetype wiring:

```lua
-- after cmp.setup(...)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zz",
  callback = function()
    require("cmp").setup.buffer({
      sources = { { name = "nvim_lsp" }, { name = "zz-snippets" } },
    })
  end,
})
```

Optional `blink.cmp` (it picks up the LSP source automatically; just
make sure `zz` filetypes are not excluded).

## Highlighting

Three layers, each enhancing the last:

1. Vim regex syntax out of the box (`{expr}` interpolation, `{{`
   escapes, strings, numbers, `zzModule` namespaces like `math.`).
2. Tree-sitter queries when the `zz` parser is installed.
3. **Semantic tokens from `zz-lsp`** (on by default): the compiler
   colors namespaces, functions, types, params and variables itself.
   Toggle with `highlight = { semantic_tokens = false }`.

Cursor reference highlighting follows `highlight.references`.

Colors come from the built-in palette (`highlight.palette`, on by
default): modules teal, functions blue, builtins yellow, types green,
consts orange, parameters red italic. Override groups with
`highlight = { colors = { zzModule = { fg = "#ff0000" } } }`, or set
`highlight = { palette = false }` for plain colorscheme links.

## Troubleshooting

**Accepting a completion inserts `()`.** Our items are bare names
(plain-text, verified by test) — the parens come from a client-side
autopairs hook, classically:

```lua
-- nvim-cmp + nvim-autopairs: skip the hook for ZZ files, or drop it
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
```

Remove that line (or guard it by filetype) and completions insert
exactly the shown name. Signature help (`(` / `<C-k>`) still shows
parameters while typing.

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
