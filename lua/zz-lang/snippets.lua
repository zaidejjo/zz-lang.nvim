-- zz-lang.nvim — snippet definitions
--
-- Registers ZZ-specific snippets.  Works with Neovim's built-in
-- snippet engine (vim.snippet on 0.10+) or luasnip if available.

local M = {}

---Snippet definitions: trigger → expansion text.
---Use tabstops: $1, $2, etc.  $0 = final cursor position.
M.snippets = {
  func = {
    trigger = "func",
    body = "func ${1:name}(${2}) -> ${3} {\n\t${0}\n}",
    description = "Function declaration",
  },
  funcnoret = {
    trigger = "funcnr",
    body = "func ${1:name}(${2}) {\n\t${0}\n}",
    description = "Function declaration (no return type)",
  },
  struct = {
    trigger = "struct",
    body = "struct ${1:Name} {\n\t${2:field}: ${3:type},\n}",
    description = "Struct declaration",
  },
  ["if"] = {
    trigger = "if",
    body = "if ${1:condition} {\n\t${0}\n}",
    description = "If expression",
  },
  ife = {
    trigger = "ife",
    body = "if ${1:condition} {\n\t${2}\n} else {\n\t${0}\n}",
    description = "If-else expression",
  },
  ["iflet"] = {
    trigger = "iflet",
    body = "if let ${1:.some(x)} = ${2:value} {\n\t${0}\n} else {\n\t\n}",
    description = "If-let expression",
  },
  ["for"] = {
    trigger = "for",
    body = "for ${1:item} in ${2:iterable} {\n\t${0}\n}",
    description = "For-in loop",
  },
  forr = {
    trigger = "forr",
    body = "for ${1:i} in 0..${2:n} {\n\t${0}\n}",
    description = "For loop over range",
  },
  ["while"] = {
    trigger = "while",
    body = "while ${1:condition} {\n\t${0}\n}",
    description = "While loop",
  },
  ["match"] = {
    trigger = "match",
    body = "match ${1:expr} {\n\t${2:.variant(v)} => ${3},\n\t${0}\n}",
    description = "Match expression",
  },
  import = {
    trigger = "import",
    body = "import ${1:std.module}",
    description = "Import statement",
  },
  ["defer"] = {
    trigger = "defer",
    body = "defer ${1:expr}",
    description = "Defer statement",
  },
  ["return"] = {
    trigger = "ret",
    body = "return ${1}",
    description = "Return statement",
  },
  ["closure"] = {
    trigger = "|",
    body = "|${1:args}| ${0}",
    description = "Closure expression",
  },
  dict = {
    trigger = "dict",
    body = "{${1:key}: ${2:value}}",
    description = "Dictionary literal",
  },
}

---Try to register snippets with luasnip, or fall back to vim.snippet.
function M.register()
  local has_luasnip, luasnip = pcall(require, "luasnip")
  if has_luasnip then
    -- Register with luasnip
    for _, snip in pairs(M.snippets) do
      luasnip.snippets["zz"] = luasnip.snippets["zz"] or {}
      table.insert(luasnip.snippets["zz"], luasnip.parser.parse_snippet(snip.trigger, snip.body))
    end
    return
  end

  -- Fallback: register as vim.keymap completions in zz buffers
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "zz",
    callback = function(ev)
      for _, snip in pairs(M.snippets) do
        vim.keymap.set("i", "<C-x><C-z>" .. snip.trigger, function()
          -- Use Neovim's native snippet expansion if available
          if vim.snippet then
            vim.snippet.expand(snip.body)
          else
            -- Ultra-fallback: just insert the body text
            local lines = vim.split(snip.body, "\n", { plain = true })
            local cursor = vim.api.nvim_win_get_cursor(0)
            vim.api.nvim_put(lines, "i", true, true)
            vim.api.nvim_win_set_cursor(0, cursor)
          end
        end, { buffer = ev.buf, desc = "ZZ snippet: " .. snip.description })
      end
    end,
    desc = "Register ZZ snippet keymaps",
  })
end

return M
