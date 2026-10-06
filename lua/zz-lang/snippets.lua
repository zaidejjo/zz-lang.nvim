-- nvim-zz — snippet definitions and completion dictionary
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
    body = '${1:s} = http.route_get(${1:s}, "${2:/path}", |${3:req}| {\n\t${0}\n})',
    description = "Register GET route (route_get)",
  },
  httproute = {
    trigger = "httproute",
    body = '${1:srv} = ${1:srv}.route("${2:GET}", "${3:/path}", |${4:req}| {\n\t${0}\n})',
    description = "Register route (any method)",
  },
  httprouteparam = {
    trigger = "httprouteparam",
    body = '${1:srv} = ${1:srv}.route("GET", "${2:/users/:id}", |${3:req}| {\n\t${4:id} := http.param(${3:req}, "id") ?? "${5}"\n\t${0}\n})',
    description = "Route with :param + http.param",
  },
  httprespond = {
    trigger = "httprespond",
    body = 'http.respond(${1:200}, ${2:body}, {"Content-Type": "${3:text/html; charset=utf-8}"})',
    description = "Response with status + headers",
  },
  httphtml = {
    trigger = "httphtml",
    body = 'http.respond(200, ${1:html}, {"Content-Type": "text/html; charset=utf-8"})',
    description = "HTML response",
  },
  httpjson = {
    trigger = "httpjson",
    body = 'http.respond(200, json.stringify(${1:v}) ?? "{}", {"Content-Type": "application/json"})',
    description = "JSON response",
  },
  httpservedir = {
    trigger = "httpservedir",
    body = '${1:srv} = http.serve_dir(${1:srv}, "${2:./public}")',
    description = "Serve static directory",
  },
  httplisten = {
    trigger = "httplisten",
    body = 'http.listen(${1:srv}, ${2:8080})',
    description = "Start blocking server",
  },
  httplistencfg = {
    trigger = "httplistencfg",
    body = 'http.listen_cfg(${1:srv}, ${2:8080}, {"shutdown_ms": ${3:800}})',
    description = "Start server with options",
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
---Generated from crates/zz_stdlib/src/funcs.rs + lib.rs (STDLIB_MODULES).
---Used to populate omnifunc and built-in completion.
M.keywords = {
  -- Keywords (all 21 — exactly the lexer's set)
  "import", "as", "func", "return", "if", "else", "while", "match",
  "struct", "for", "in", "break", "continue", "defer",
  "pub", "impl", "const", "extern",

  -- Booleans
  "true", "false",

  -- Built-in types
  "int", "float", "bool", "str", "unit", "void",

  -- Generic types
  "Option", "Result",

  -- Variant constructors
  ".ok", ".err", ".some", ".none",

  -- Top-level builtins (no import required)
  "print", "println", "input",
  "range", "len", "map", "filter", "enumerate", "zip",
  "typeof", "str", "int", "float", "dbg", "append",
  "assert", "assert_eq", "assert_ne", "assert_approx_eq", "fail", "panic",

  -- std.str
  "str.length", "str.split", "str.contains",
  "str.trim", "str.trim_start", "str.trim_end",
  "str.to_upper", "str.to_lower",
  "str.replace", "str.starts_with", "str.ends_with",
  "str.join", "str.join_parts", "str.repeat", "str.count",
  "str.is_empty", "str.reverse",
  "str.pad_left", "str.pad_right",
  "str.builder", "str.push_part", "str.finish",
  "str.builder_len",

  -- std.vec
  "vec.len", "vec.push", "vec.pop", "vec.enumerate",
  "vec.fold", "vec.sum", "vec.product",
  "vec.min_val", "vec.max_val", "vec.sum_f", "vec.product_f",
  "vec.concat", "vec.flatten", "vec.index_of", "vec.last_index_of",

  -- std.bytes
  "bytes.len", "bytes.builder", "bytes.push_byte",
  "bytes.extend", "bytes.len_of", "bytes.from_ints",

  -- std.json
  "json.parse", "json.stringify", "json.get",
  "json.as_str", "json.as_int", "json.as_float", "json.as_bool",
  "json.null", "json.pretty", "json.type", "json.len", "json.keys",
  "json.has", "json.merge", "json.deep_get", "json.array_push",
  "json.validate", "json.parse_or", "json.parse_or_null",
  "json.path_exists", "json.path_get_or",
  "json.is_null", "json.is_bool", "json.is_number", "json.is_string",
  "json.is_array", "json.is_object", "json.is_empty",

  -- std.http
  "http.server", "http.route", "http.route_get", "http.route_post",
  "http.route_put", "http.route_delete",
  "http.get", "http.post", "http.put", "http.delete",
  "http.fetch", "http.fetch_insecure", "http.post_json",
  "http.handle", "http.listen", "http.listen_cfg",
  "http.listen_tls", "http.listen_tls_cfg",
  "http.log", "http.use", "http.pipe", "http.pipe_post",
  "http.serve_dir", "http.serve_dir_at", "http.hijack",
  "http.rate_limit", "http.with_headers",
  "http.test", "http.test_req",
  "http.respond", "http.ok", "http.created",
  "http.not_found", "http.redirect",
  "http.param", "http.query", "http.header",
  "http.body_json", "http.body_form", "http.body_bytes",
  "http.cors", "http.secure_headers", "http.secure_header_dict",
  "http.csrf_token", "http.csrf_check", "http.request_id",

  -- std.fs
  "fs.read_file", "fs.read", "fs.read_to_string", "fs.read_bytes",
  "fs.write_file", "fs.write", "fs.append",
  "fs.copy", "fs.move", "fs.rename",
  "fs.exists", "fs.is_file", "fs.is_dir",
  "fs.remove_file", "fs.remove", "fs.mkdir", "fs.mkdir_all",
  "fs.read_dir", "fs.readdir", "fs.remove_dir_all", "fs.walk_dir",
  "fs.stat", "fs.normalize", "fs.join", "fs.basename", "fs.dirname",
  "fs.is_absolute", "fs.extension",
  "fs.osfs", "fs.memfs", "fs.tarfs", "fs.embedfs",

  -- std.path
  "path.join", "path.join_all", "path.normalize", "path.basename",
  "path.dirname", "path.is_absolute", "path.extension",

  -- std.env
  "env.get_var", "env.var", "env.args", "env.get", "env.set",
  "env.remove", "env.unset", "env.vars", "env.cwd", "env.set_cwd",
  "env.exe_path", "env.home_dir", "env.temp_dir",
  "env.user", "env.os", "env.arch",

  -- std.math
  "math.abs", "math.floor", "math.ceil", "math.sqrt", "math.pow",
  "math.random", "math.round", "math.trunc", "math.clamp",
  "math.signum", "math.hypot", "math.is_nan", "math.is_inf",
  "math.root", "math.isqrt", "math.factorial", "math.gcd", "math.lcm",
  "math.sin", "math.cos", "math.tan",
  "math.asin", "math.acos", "math.atan",
  "math.sin_deg", "math.cos_deg", "math.tan_deg",
  "math.to_radians", "math.to_degrees",
  "math.log", "math.log10", "math.exp",
  "math.dot_product", "math.magnitude", "math.matrix_mul",
  "math.mean", "math.median", "math.rand_range",
  "math.sum", "math.product", "math.count",
  "math.min", "math.max", "math.is_even", "math.is_odd",
  "math.min_arr", "math.max_arr", "math.sum_f", "math.product_f",
  "math.mean_f", "math.median_f",
  "math.PI", "math.E", "math.TAU",

  -- std.time
  "time.now_ms", "time.now_nanos", "time.now_micros",
  "time.monotonic_nanos", "time.sleep_ms", "time.sleep_micros",
  "time.sleep", "time.make_date", "time.parse_rfc3339",
  "time.format_rfc3339", "time.add_days", "time.diff_days",
  "time.to_epoch_days", "time.from_epoch_days", "time.is_leap",

  -- std.encoding
  "encoding.base64_encode", "encoding.base64_decode",
  "encoding.base64_decode_bytes",
  "encoding.hex_encode", "encoding.hex_decode",
  "encoding.url_encode", "encoding.url_decode",

  -- std.net
  "net.tcp_connect", "net.tcp_listen", "net.tcp_accept",
  "net.tcp_write", "net.tcp_read", "net.tcp_readline",
  "net.tcp_close", "net.tcp_read_bytes", "net.tcp_write_bytes",
  "net.tcp_shutdown",

  -- std.chan / std.task
  "chan.new", "chan.send", "chan.recv", "chan.try_recv",
  "task.spawn", "task.join", "task.try_join",

  -- std.regexp
  "regexp.compile", "regexp.is_match", "regexp.find",
  "regexp.replace_all", "regexp.captures", "regexp.is_email",

  -- std.crypto
  "crypto.sha256", "crypto.sha256_bytes", "crypto.sha512",
  "crypto.hmac_sha256", "crypto.random_bytes", "crypto.ct_eq",
  "crypto.argon2_hash", "crypto.argon2_verify",
  "crypto.bcrypt_hash", "crypto.bcrypt_verify",
  "crypto.ed25519_keypair", "crypto.ed25519_sign",
  "crypto.ed25519_verify",
  "crypto.jwt_encode", "crypto.jwt_decode",

  -- std.log
  "log.trace", "log.debug", "log.info", "log.warn", "log.error",
  "log.set_level", "log.get_level",

  -- std.sys
  "sys.os", "sys.arch", "sys.cpu_count",
  "sys.hostname", "sys.total_mem", "sys.avail_mem",

  -- std.args
  "args.parse", "args.get_str", "args.get_int", "args.get_bool",
  "args.positional", "args.subcommand", "args.help",

  -- std.process
  "process.run", "process.run_with_env", "process.spawn",
  "process.wait", "process.exit", "process.pid",

  -- std.uuid
  "uuid.v4", "uuid.v7", "uuid.parse", "uuid.is_valid",

  -- std.sqlz / std.db
  "sqlz.open", "sqlz.exec", "sqlz.query",
  "sqlz.close", "sqlz.transaction",
  "db.open", "db.exec", "db.query", "db.close", "db.transaction",

  -- std.colors
  "colors.red", "colors.green", "colors.yellow", "colors.blue",
  "colors.magenta", "colors.cyan", "colors.white",
  "colors.bold", "colors.dim", "colors.italic", "colors.underline",
  "colors.reset", "colors.rgb", "colors.hex",

  -- std.term
  "term.enable_raw", "term.disable_raw", "term.read_key",
  "term.get_size", "term.is_tty", "term.flush",

  -- std.test
  "test.assert", "test.assert_eq", "test.assert_ne",
  "test.assert_approx_eq", "test.fail",

  -- std.map / std.set
  "map.has", "map.get_or", "map.keys", "map.values",
  "map.len", "map.is_empty", "map.merge", "map.remove",
  "set.has", "set.insert", "set.remove", "set.union",
  "set.intersect", "set.diff", "set.len", "set.is_empty",

  -- std.dec
  "dec.is_valid", "dec.add", "dec.sub", "dec.mul",
  "dec.cmp", "dec.eq", "dec.lt", "dec.gt", "dec.format",

  -- std.csv
  "csv.parse", "csv.parse_delim", "csv.stringify",
  "csv.stringify_delim", "csv.header", "csv.records",
  "csv.len", "csv.get_cell", "csv.validate", "csv.to_json",

  -- Option/Result methods
  "option.unwrap", "option.unwrap_or", "option.expect",
  "result.unwrap", "result.unwrap_or", "result.expect",

  -- Operators (word forms, if any)
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

  -- Search the keyword dictionary (enriched with signatures from docs.lua),
  -- then the full generated stdlib database (887 entries: both spellings).
  local ok_docs, docs = pcall(require, "zz-lang.docs")
  local seen = {}
  local matches = {}
  local function push(word, sig)
    if not seen[word] then
      seen[word] = true
      table.insert(matches, { word = word, kind = "ZZ", menu = sig or "" })
    end
  end
  for _, kw in ipairs(M.keywords) do
    if kw:find(base, 1, true) == 1 then
      local sig = ok_docs and docs.get(kw) and docs.get(kw).sig or ""
      push(kw, sig)
    end
  end
  if ok_docs then
    for name, entry in pairs(docs.docs) do
      if name:find(base, 1, true) == 1 then
        push(name, entry.sig)
      else
        -- also match on the short suffix: "serve_dir" finds http.serve_dir
        local short = name:match("%.([^.]+)$")
        if short and short:find(base, 1, true) == 1 then
          push(name, entry.sig)
        end
      end
    end
    -- snippet triggers complete too (expand via luasnip/cmp/snippet engine)
    for _, snip in pairs(M.snippets) do
      if snip.trigger:find(base, 1, true) == 1 then
        push(snip.trigger, snip.description)
      end
    end
  end
  return matches
end

return M
