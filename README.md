# nvim-zz

Neovim plugin for [ZZ](https://github.com/zz-language/zz). Zero dependencies — uses the built-in LSP client. Docs: <https://zz-lang.pages.dev>.

## Requirements

Neovim >= 0.8, plus the `zz` CLI and `zz-lsp` binary in `$PATH`:

```bash
cargo install --path crates/zz_cli
cargo build --release -p zz_lsp && mkdir -p ~/.zz/bin && \
  cp target/release/zz-lsp ~/.zz/bin/zz-lsp.new && \
  mv ~/.zz/bin/zz-lsp.new ~/.zz/bin/zz-lsp
```

(`mv` over rename, never `cp` onto the old file: copying onto a
running binary fails with ETXTBSY. Make sure `~/.zz/bin` is in
`$PATH` — and that no older `zz-lsp` in `/usr/local/bin` shadows it;
`:checkhealth nvim-zz` prints the exact binary Neovim spawns.)

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

Colors come from your colorscheme, not hardcoded hexes: every `zz*`
group links to a standard theme group (modules → `Include`,
functions → `Function`, builtins → `Special`, types → `Type`,
consts → `Constant`, variables → `Identifier`), and server semantic
tokens follow the same groups — one tweak per category. Override a
single group with `highlight = { colors = { zzModule = { fg =
"#ff0000" } } }`, or set `highlight = { palette = false }` for plain
syntax defaults.

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
| `<leader>rn` / `<leader>ca` | Rename / code action (quickfixes: remove unused import, apply suggestions; visual mode supported) |
| `<leader>f` | Format buffer |
| `<leader>th` | Toggle inlay hints (inferred `:=` types, arg names) |
| `]d` / `[d` | Next / previous diagnostic |

## Commands

`:ZZRun` `:ZZCheck` `:ZZFmt` `:ZZTest` `:ZZBuild` — act on the current file. `:ZZDoc` shows stdlib help for the word under the cursor. `:ZZDiag` shows line diagnostics. `:ZZUpdateServer` rebuilds `zz-lsp` from your zz_lang checkout (auto-detected via `lsp.source_dir`, `$ZZ_LANG_ROOT`, or `~/Projects/zz_lang`), installs it where Neovim actually spawns it from, and restarts the client — run it whenever diagnostics look stale after a compiler update.

Snippets (`func`, `match`, `httproute`, …) register with luasnip/cmp automatically, omnifunc otherwise. `gf` follows `import`s.

## License

MIT
