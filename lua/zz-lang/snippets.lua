-- zz-lang.nvim — snippet definitions and completion dictionary
--
-- ZZ-specific snippets: works with Neovim's built-in snippet engine
-- (vim.snippet on 0.10+), luasnip, or a basic keymap fallback.
--
-- Also provides a keyword/builtin completion dictionary for omnicomplete.

local M = {}

-- ══════════════════════════════════════════════════════════════════════════
-- SNIPPETS
-- ══════════════════════════════════════════════════════════════════════════

---Snippet definitions: trigger → expansion text.
---Use tabstops: $1, $2, etc.  $0 = final cursor position.
M.snippets = {
  -- ── Declarations ───────────────────────────────────────────────────────
  func = {
    trigger = "func",
    body = "func ${1:name}(${2}) -> ${3} {\n\t${0}\n}",
    description = "Function with return type",
  },
  funcnr = {
    trigger = "funcnr",
    body = "func ${1:name}(${2}) {\n\t${0}\n}",
    description = "Function (no return type)",
  },
  funcgen = {
    trigger = "funcgen",
    body = "func ${1:name}<${2:T}>(${3}) -> ${4} {\n\t${0}\n}",
    description = "Generic function",
  },
  struct = {
    trigger = "struct",
    body = "struct ${1:Name} {\n\t${2:field}: ${3:type},\n}",
    description = "Struct declaration",
  },

  -- ── Explicit type declarations (name: type = value) ──────────────────────
  decl = {
    trigger = "decl",
    body = "${1:name}: ${2:type} = ${3:value}",
    description = "Explicit type declaration (name: type = value)",
  },
  declint = {
    trigger = "declint",
    body = "${1:name}: int = ${2:0}",
    description = "Explicit int declaration",
  },
  declstr = {
    trigger = "declstr",
    body = '${1:name}: str = "${2:value}"',
    description = "Explicit str declaration",
  },
  declfloat = {
    trigger = "declfloat",
    body = "${1:name}: float = ${2:0.0}",
    description = "Explicit float declaration",
  },
  declbool = {
    trigger = "declbool",
    body = "${1:name}: bool = ${2:true}",
    description = "Explicit bool declaration",
  },
  declopt = {
    trigger = "declopt",
    body = "${1:name}: Option<${2:type}> = ${3:.none}",
    description = "Explicit Option declaration",
  },
  declres = {
    trigger = "declres",
    body = "${1:name}: Result<${2:T}, ${3:E}> = ${4:.ok(0)}",
    description = "Explicit Result declaration",
  },
  declarr = {
    trigger = "declarr",
    body = "${1:name}: [${2:type}] = [${3}]",
    description = "Explicit array declaration",
  },
  decldict = {
    trigger = "decldict",
    body = "${1:name}: {${2:str}: ${3:int}} = {${4}}",
    description = "Explicit dict declaration",
  },

  -- ── Control flow ───────────────────────────────────────────────────────
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
  ifelif = {
    trigger = "ifelif",
    body = "if ${1:a} {\n\t${2}\n} else if ${3:b} {\n\t${4}\n} else {\n\t${0}\n}",
    description = "If-else if-else chain",
  },
  iflet = {
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
  ["return"] = {
    trigger = "ret",
    body = "return ${1}",
    description = "Return statement",
  },
  ["defer"] = {
    trigger = "defer",
    body = "defer ${1:expr}",
    description = "Defer statement",
  },

  -- ── Imports & modules ──────────────────────────────────────────────────
  import = {
    trigger = "import",
    body = "import ${1:std.module}",
    description = "Import statement",
  },
  importas = {
    trigger = "importas",
    body = "import ${1:std.module} as ${2:alias}",
    description = "Import with alias",
  },

  -- ── Expressions ────────────────────────────────────────────────────────
  closure = {
    trigger = "|",
    body = "|${1:args}| ${0}",
    description = "Closure expression",
  },
  dict = {
    trigger = "dict",
    body = "{${1:key}: ${2:value}}",
    description = "Dictionary literal",
  },
  array = {
    trigger = "arr",
    body = "[${1:elem}, ${0}]",
    description = "Array literal",
  },
  try = {
    trigger = "try",
    body = "${1:expr}?",
    description = "Try (unwrap Result with ?)",
  },
  elvis = {
    trigger = "elvis",
    body = "${1:expr} ?? ${0:fallback}",
    description = "Elvis operator (unwrap or fallback)",
  },
  pipe = {
    trigger = "pipe",
    body = "${1:expr} |> ${0:func}",
    description = "Pipeline operator",
  },

  -- ── Stdlib: IO ─────────────────────────────────────────────────────────
  println = {
    trigger = "println",
    body = 'println("${1:text}")',
    description = "Print with newline",
  },
  print = {
    trigger = "print",
    body = 'print("${1:text}")',
    description = "Print without newline",
  },
  printfln = {
    trigger = "printfln",
    body = 'println("${1:{expr}}")',
    description = "Print formatted with newline",
  },

  -- ── Stdlib: String ─────────────────────────────────────────────────────
  strsplit = {
    trigger = "strsplit",
    body = "${1:s} |> str.split(\"${2:sep}\")",
    description = "Split string by separator",
  },
  strtrim = {
    trigger = "strtrim",
    body = "${1:s} |> str.trim()",
    description = "Trim whitespace",
  },
  strlen = {
    trigger = "strlen",
    body = "${1:s} |> str.length()",
    description = "String length",
  },

  -- ── Stdlib: Vec ────────────────────────────────────────────────────────
  vecpush = {
    trigger = "vecpush",
    body = "${1:v} |> vec.push(${2:elem})",
    description = "Push to vector",
  },
  veclen = {
    trigger = "veclen",
    body = "${1:v} |> vec.len()",
    description = "Vector length",
  },

  -- ── Stdlib: Option/Result ──────────────────────────────────────────────
  unwrap = {
    trigger = "unwrap",
    body = "${1:expr}.unwrap()",
    description = "Unwrap Option or Result",
  },
  unwrapor = {
    trigger = "unwrapor",
    body = "${1:expr}.unwrap_or(${2:default})",
    description = "Unwrap with default",
  },

  -- ── Stdlib: Math ───────────────────────────────────────────────────────
  mabs = {
    trigger = "mabs",
    body = "${1:n} |> math.abs()",
    description = "Absolute value",
  },

  -- ── Stdlib: Filesystem ─────────────────────────────────────────────────
  readfile = {
    trigger = "readfile",
    body = 'fs.read_file("${1:path}")',
    description = "Read file contents",
  },
  writefile = {
    trigger = "writefile",
    body = 'fs.write_file("${1:path}", ${2:contents})',
    description = "Write file contents",
  },

  -- ── Stdlib: JSON ───────────────────────────────────────────────────────
  jsonparse = {
    trigger = "jsonparse",
    body = 'json.parse(${1:s})',
    description = "Parse JSON string",
  },
  jsonstringify = {
    trigger = "jsonstringify",
    body = 'json.stringify(${1:v})',
    description = "Serialize to JSON string",
  },

  -- ── Stdlib: HTTP ───────────────────────────────────────────────────────
  httpserver = {
    trigger = "httpserver",
    body = 'http.server()',
    description = "Create HTTP server",
  },
  httpget = {
    trigger = "httpget",
    body = '${1:srv} |> http.get("${2:/path}", |${3:req}| {\n\t${0}\n})',
    description = "Register GET route",
  },

  -- ── Stdlib: Env ────────────────────────────────────────────────────────
  getenv = {
    trigger = "getenv",
    body = 'env.get_var("${1:NAME}")',
    description = "Get environment variable",
  },

  -- ── Stdlib: Time ───────────────────────────────────────────────────────
  nowms = {
    trigger = "nowms",
    body = "time.now_ms()",
    description = "Current time in milliseconds",
  },
  sleepms = {
    trigger = "sleepms",
    body = "time.sleep_ms(${1:ms})",
    description = "Sleep for N milliseconds",
  },

  -- ── Type conversions ───────────────────────────────────────────────────
  tostr = {
    trigger = "tostr",
    body = "str(${1:v})",
    description = "Convert to string",
  },
  toint = {
    trigger = "toint",
    body = "int(${1:v})",
    description = "Convert to int",
  },
  tofloat = {
    trigger = "tofloat",
    body = "float(${1:v})",
    description = "Convert to float",
  },
  typeof = {
    trigger = "typeof",
    body = "typeof(${1:v})",
    description = "Get type name as string",
  },

  -- ── List comprehension ─────────────────────────────────────────────────
  listcomp = {
    trigger = "lc",
    body = "[${1:expr} for ${2:x} in ${3:iter}]",
    description = "List comprehension",
  },
  listcompif = {
    trigger = "lcf",
    body = "[${1:expr} for ${2:x} in ${3:iter} if ${4:cond}]",
    description = "List comprehension with filter",
  },

  -- ── Option/Result patterns ───────────────────────────────────────────────
  optsome = {
    trigger = "optsome",
    body = "${1:name}: Option<${2:type}> = .some(${3:value})",
    description = "Option with some value",
  },
  optnone = {
    trigger = "optnone",
    body = "${1:name}: Option<${2:type}> = .none",
    description = "Option with none",
  },
  optmatch = {
    trigger = "optmatch",
    body = "match ${1:opt} {\n\t.some(${2:v}) => ${3},\n\t.none => ${0},\n}",
    description = "Match on Option",
  },
  resok = {
    trigger = "resok",
    body = "${1:name}: Result<${2:T}, ${3:E}> = .ok(${4:value})",
    description = "Result with ok value",
  },
  reserr = {
    trigger = "reserr",
    body = "${1:name}: Result<${2:T}, ${3:E}> = .err(${4:error})",
    description = "Result with error",
  },
  resmatch = {
    trigger = "resmatch",
    body = "match ${1:res} {\n\t.ok(${2:v}) => ${3},\n\t.err(${4:e}) => ${0},\n}",
    description = "Match on Result",
  },
  optmap = {
    trigger = "optmap",
    body = "${1:opt} |> map(|${2:x}| ${3})",
    description = "Map over Option",
  },
  resmap = {
    trigger = "resmap",
    body = "${1:res} |> map(|${2:v}| ${3})",
    description = "Map over Result",
  },
  optandthen = {
    trigger = "optand",
    body = "${1:opt} |> and_then(|${2:x}| ${3})",
    description = "Chain Option with and_then",
  },
  resandthen = {
    trigger = "resand",
    body = "${1:res} |> and_then(|${2:v}| ${3})",
    description = "Chain Result with and_then",
  },
}

-- ══════════════════════════════════════════════════════════════════════════
-- COMPLETION DICTIONARY (for omnifunc / manual completion)
-- ══════════════════════════════════════════════════════════════════════════

---All ZZ keywords, builtins, types, and stdlib functions.
---Used to populate omnifunc and built-in completion.
M.keywords = {
  -- Keywords
  "import", "as", "func", "return", "if", "else", "while", "match",
  "struct", "for", "in", "break", "continue", "defer",

  -- Booleans
  "true", "false",

  -- Built-in types
  "int", "float", "bool", "str",

  -- Generic types
  "Option", "Result",

  -- Variant constructors
  ".ok", ".err", ".some", ".none",

  -- Top-level builtins (no import required)
  "print", "println", "input",
  "len", "map", "filter", "enumerate", "zip", "range",
  "typeof", "str", "int", "float",

  -- std.io
  "io.printz", "io.println", "io.read_line",

  -- std.str
  "str.length", "str.split", "str.contains",
  "str.trim", "str.to_upper", "str.to_lower",
  "str.replace", "str.starts_with", "str.ends_with",

  -- std.vec
  "vec.len", "vec.push", "vec.pop", "vec.reverse",
  "vec.join", "vec.contains", "vec.sort", "vec.insert", "vec.remove",

  -- std.math
  "math.abs", "math.floor", "math.ceil", "math.sqrt", "math.pow", "math.random",

  -- std.json
  "json.parse", "json.stringify", "json.get",
  "json.as_str", "json.as_int", "json.as_float", "json.as_bool",

  -- std.http
  "http.server", "http.get", "http.post", "http.handle", "http.listen",

  -- std.fs
  "fs.read_file", "fs.write_file", "fs.exists",

  -- std.env
  "env.get_var", "env.args",

  -- std.time
  "time.now_ms", "time.sleep_ms",

  -- Option/Result methods
  "option.unwrap", "option.unwrap_or", "option.expect",
  "result.unwrap", "result.unwrap_or", "result.expect",

  -- Iteration builtins
  "for", "in", "if", "while",

  -- Operators
  "and", "or", "not",
}

-- ══════════════════════════════════════════════════════════════════════════
-- REGISTRATION
-- ══════════════════════════════════════════════════════════════════════════

---Register snippets with luasnip, cmp, or fallback keymaps.
function M.register()
  -- 1. Try luasnip
  local has_luasnip, luasnip = pcall(require, "luasnip")
  if has_luasnip then
    local zz_snips = {}
    for _, snip in pairs(M.snippets) do
      table.insert(zz_snips, luasnip.parser.parse_snippet(snip.trigger, snip.body, {
        description = snip.description,
      }))
    end
    luasnip.filetype_set("zz", { snippets = zz_snips })
    return
  end

  -- 2. Try nvim-cmp: register a snippet source via cmp's Lua API
  local ok_cmp, cmp = pcall(require, "cmp")
  if ok_cmp then
    -- cmp source: feed snippet completions
    cmp.register_source(setmetatable({
      name = "zz-snippets",
      complete = function(_, callback)
        local items = {}
        for _, snip in pairs(M.snippets) do
          table.insert(items, {
            label = snip.trigger,
            kind = vim.lsp.protocol.CompletionItemKind.Snippet,
            detail = snip.description,
            insertText = snip.body,
            insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
          })
        end
        callback(items)
      end,
    }, {
      __index = function(_, _method)
        return function() end
      end,
    }))
  end

  -- 3. Build omnifunc from keyword dictionary
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "zz",
    callback = function(ev)
      vim.bo[ev.buf].omnifunc = "v:lua.zz_omnifunc"

      -- Set buffer keyword completion (K omnifunc)
      vim.bo[ev.buf].complete = "k"
    end,
    desc = "Set ZZ omnifunc and completion",
  })
end

---Omnicomplete function for ZZ buffers (referenced from omnifunc).
---Collects matching keywords from the dictionary.
---@return table
function _G.zz_omnifunc(findstart, base)
  if findstart == 1 then
    -- Find start of the word to complete
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local start = col
    while start > 0 do
      local c = line:sub(start, start)
      if c:match("[%w.]") then
        start = start - 1
      else
        break
      end
    end
    return start
  end

  -- Search the keyword dictionary
  local matches = {}
  for _, kw in ipairs(M.keywords) do
    if kw:find(base, 1, true) == 1 then
      table.insert(matches, {
        word = kw,
        kind = "ZZ",
        menu = "",
      })
    end
  end
  return matches
end

return M
