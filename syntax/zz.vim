" nvim-zz — syntax highlighting for ZZ
"
" Generated from the authoritative lexer:
"   crates/zz_frontend/src/token.rs + crates/zz_frontend/src/lexer/mod.rs
" Keywords (21), full operator set incl. compound assigns, `"""` triple
" strings with interpolation, \{ \} \e \xHH escapes, // /* */ comments.

if exists("b:current_syntax")
  finish
endif

" ── Comments ──────────────────────────────────────────────────────────────
" Line comments: // starts anywhere outside strings (matches the lexer).
" String regions protect URLs since they start earlier. Block comments nest.

syn match zzComment /\/\/.*/ contains=@Spell,zzTodo
syn region zzComment start="/\*" end="\*/" contains=zzComment,zzTodo,@Spell fold
syn keyword zzTodo TODO FIXME NOTE HACK XXX BUG contained

" ── Keywords (all 21 — exactly the lexer's set) ──────────────────────────
syn keyword zzKeyword
      \ as func return if else while match
      \ struct for in break continue defer
      \ pub impl const extern
syn keyword zzImportKw import nextgroup=zzImportPath skipwhite

syn keyword zzBoolean true false

" ── Types ─────────────────────────────────────────────────────────────────
" Lowercase primitives are contextual idents in the grammar, plus the two
" generic constructors. Matches type position loosely (good enough for Vim).
syn keyword zzType int float bool str unit void
syn keyword zzTypeBuiltin Option Result

" ── Top-level builtins (no import required) ───────────────────────────────
" Exactly zz_stdlib top-level: no std.io module exists (io.* words removed).
syn keyword zzBuiltin print println input
      \ range len map filter enumerate zip typeof
      \ str int float dbg append
      \ assert assert_eq assert_ne assert_approx_eq fail panic

" ── Stdlib modules (receivers / namespaces) ───────────────────────────────
" `str.` `http.` … — highlighted so namespaced calls read as one unit.
" The trailing dot is optional so the last import segment (`import std.math`
" → `math`) colors too; a bare word match elsewhere is harmless.
syn match zzModule
      \ /\<\(std\|str\|vec\|bytes\|json\|http\|fs\|file\|path\|env\|math\|time\|encoding\|net\|chan\|task\|regexp\|crypto\|log\|span\|sys\|args\|process\|uuid\|sqlz\|db\|colors\|term\|test\|map\|set\|dec\|csv\|option\|result\|File\|ArgsParser\|Regexp\)\(\.\|(\|$\)/

" ── Import statements (structural chain) ────────────────────────────────
" `import std.math as m` / `import std.math(PI, E as ee)` / `import a(*)`.
" nextgroup keeps the chain tight: path, then either an alias or the
" selective list. Defined after zzModule so import roles win on overlap.
syn match zzImportPath /[A-Za-z_][A-Za-z0-9_.]*/ contained nextgroup=zzImportList,zzImportAs skipwhite
syn keyword zzImportAs as contained nextgroup=zzImportAlias skipwhite
syn match zzImportAlias /[A-Za-z_]\w*/ contained
syn region zzImportList matchgroup=zzDelimiter start=/(/ end=/)/ contained
      \ contains=zzImportName,zzImportAs,zzOperator
syn match zzImportName /[A-Za-z_]\w*/ contained

" ── Stdlib members, bare (selective imports: pow, sin, …) ────────────────
" Leaf names from the live registry (stdlib_funcs + stdlib_consts).
" Builtins/keywords/types keep their own groups (excluded here);
" contains/end/extend/fold go through zzStdFuncOp (syntax keywords).
" Regenerate: temp zz_stdlib test dumping keys, filter, paste below.
syn keyword zzStdFunc
      \ E INF LN_10 LN_2 LOG10_E LOG2_E NAN PI SQRT_1_2 SQRT_2 TAU abs
      \ accept acos add add_days append_at arch argon2_hash argon2_verify
      \ array_push as_bool as_float as_int as_str asin atan avail_mem
      \ base64_decode base64_decode_bytes base64_encode basename bcrypt_hash
      \ bcrypt_verify bg_black bg_blue bg_cyan bg_green bg_magenta bg_red
      \ bg_rgb bg_white bg_yellow black blue body_bytes body_form body_json
      \ bold bool_flag bright_black bright_blue bright_cyan bright_green
      \ bright_magenta bright_red bright_white bright_yellow builder
      \ builder_len captures ceil civil_from_days clamp clamp255 close cmp
      \ compile concat connect copy cors cos cos_deg count cpu_count created
      \ csrf_check csrf_token ct_eq cwd cyan date_valid days_from_civil
      \ days_in_month debug deep_get delete delim_first diff diff_days dim
      \ dirname disable_raw dot_product ed25519_keypair ed25519_sign
      \ ed25519_verify embedfs enable_raw ends_with epoch_fallback eq error
      \ escape_cell exe_path exec exists exists_at exit exp expect extension
      \ factorial fetch fetch_insecure find finish flatten floor flush
      \ format format_rfc3339 from_epoch_days from_ints from_scaled gcd get
      \ get_bool get_cell get_int get_level get_or get_raw get_size get_str
      \ get_var green gt handle has has_int header headers help hex hex3
      \ hex6 hex_byte hex_decode hex_encode hex_val hijack hmac_sha256
      \ home_dir hostname hypot index_of info insert insert_int int_flag
      \ intersect intersect_int is_absolute is_array is_bool is_dir
      \ is_dir_at is_email is_empty is_even is_file is_file_at is_inf
      \ is_leap is_match is_nan is_null is_number is_object is_odd is_string
      \ is_tty is_valid isqrt italic join join_all join_parts json_escape
      \ jwt_decode jwt_decode_ed jwt_encode jwt_encode_ed keys keys_str
      \ last_index_of lcm len_of length listen listen_cfg listen_tls
      \ listen_tls_cfg local_addr log10 lt magenta magnitude make_date
      \ matrix_mul max max_arr max_val mean mean_f median median_f memfs
      \ merge merge_str micros millis min min_arr min_val mkdir mkdir_all
      \ mkdir_all_at monotonic_nanos move mul needs_quote new normalize
      \ not_found now_micros now_ms now_nanos null ok open os osfs pad2
      \ pad_left pad_right param parse parse_delim parse_or parse_or_null
      \ parse_rfc3339 parser path_exists path_get_or peer_addr pid pipe
      \ pipe_post pop positional post post_json pow pow10 pretty product
      \ product_f push push_byte push_part put query rand_range random
      \ random_bytes rate_limit read read_bytes read_bytes_at read_chunk
      \ read_chunk_bytes read_dir read_dir_at read_file read_key read_line
      \ read_to_string read_to_string_at readdir records recv red redirect
      \ remove remove_dir_all remove_file remove_file_at remove_int rename
      \ repeat replace replace_all request_id reset respond reverse rgb root
      \ round route route_delete route_get route_post route_put rsa_keypair
      \ rsa_sign rsa_verify run run_with_env scale_of secs
      \ secure_header_dict secure_headers seek send serve_dir serve_dir_at
      \ server set_cwd set_format set_level set_read_timeout
      \ set_write_timeout sha256 sha256_bytes sha512 shutdown signum sin
      \ sin_deg sleep sleep_micros sleep_ms sort span_begin spawn split sqrt
      \ starts_with stat status str_flag stringify stringify_delim strip sub
      \ subcommand sum sum_f tan tan_deg tarfs tcp_accept tcp_close
      \ tcp_connect tcp_listen tcp_read tcp_read_bytes tcp_readline
      \ tcp_shutdown tcp_write tcp_write_bytes temp_dir test_req text
      \ to_degrees to_epoch_days to_file to_json to_lower to_micros
      \ to_millis to_nanos to_radians to_scaled to_secs to_stderr to_upper
      \ total_mem trace transaction trim trim_end trim_start trim_zeros
      \ trunc try_join try_recv type underline union union_int unset unwrap
      \ unwrap_or url_decode url_encode use user v4 v7 validate values
      \ values_str var vars wait walk_dir warn was_help white with_headers
      \ write write_at write_bytes write_chunk write_file yellow
syn match zzStdFuncOp /\<\(contains\|end\|extend\|fold\)\>/

" ── Decorators ────────────────────────────────────────────────────────────
syn match zzDecorator /@\w\+/

" ── Operators (longest first — order matters) ─────────────────────────────
" Power / shifts / compound assigns (greedy **= <<= >>= like the lexer)
syn match zzOperator /\*\*=/
syn match zzOperator /<<=/
syn match zzOperator />>=/
syn match zzOperator /\*\*/
syn match zzOperator /<</
syn match zzOperator />>/
syn match zzOperator /[+\-*\/%&|^]=/
" Comparison
syn match zzOperator /==/
syn match zzOperator /!=/
syn match zzOperator /<=/
syn match zzOperator />=/
syn match zzOperator /[<>]/
" Logical / Elvis / try
syn match zzOperator /&&/
syn match zzOperator /||/
syn match zzOperator /??/
syn match zzOperator /\%(^\|[^:]\)\@<=!/ " lone ! (not !=, not // comment)
" Declaration / arrows / ranges / pipes
syn match zzOperator /:=/
syn match zzOperator /=>/
syn match zzOperator /->/
syn match zzOperator /\.\./
syn match zzOperator /|>/
" Singles (= after :=, : used in types, ? try, . field, | closure, & ^ ~)
" Bare arithmetic last of all: multi-char forms above win at each spot.
syn match zzOperator /[+\-*\/%]/
syn match zzOperator /=/
syn match zzOperator /\%([:]\)\@<!:\%([:]\)\@!/ " lone : (not ::)
syn match zzOperator /?/
syn match zzOperator /\.\%(\.\)\@!/
syn match zzOperator /|/
syn match zzOperator /[&^~]/
syn match zzOperator /;/
syn match zzOperator /,/

" ── Delimiters ────────────────────────────────────────────────────────────
syn match zzDelimiter /[()\[\]{}]/

" ── Strings ───────────────────────────────────────────────────────────────
" Escapes are identical in both modes: \n \t \r \\ \" \{ \} \e \xHH.
" `{{` and `}}` stay literal (highlighted as escapes); both string modes
" interpolate {ident, {digit and {( — doubled braces for a literal `{`.
syn match zzEscape /\\[ntr\\"{}e]/ contained
syn match zzEscape /\\x\x\{2}/ contained
syn match zzBraceEscape /{{/ contained
syn match zzBraceEscape /}}/ contained

" Single-line "..." — newline terminates (oneline)
syn region zzString start=/"/ skip=/\\"/ end=/"/ oneline
      \ contains=zzEscape,zzBraceEscape,zzInterp

" Interpolation in "...": { + ident / digit / paren (same rule as
" """...""", since the lexer widened single-line triggers; {{
" stays an escape — zzBraceEscape wins because `{` alone never matches)
syn region zzInterp matchgroup=zzInterpBrace start=/{[A-Za-z0-9_(]/
      \ end=/}/ contained
      \ contains=zzKeyword,zzBoolean,zzType,zzTypeBuiltin,zzBuiltin,
      \ zzModule,zzDecorator,zzOperator,zzDelimiter,
      \ zzInt,zzFloat,zzString,zzStringTriple,zzEscape,zzVariant,zzFuncName

" Triple """...""" — newlines allowed, dedented by the lexer (keepend)
syn region zzStringTriple start=/"""/ end=/"""/
      \ contains=zzEscape,zzBraceEscape,zzInterpTriple keepend

" Interpolation in """...""": { + ident / digit / paren
syn region zzInterpTriple matchgroup=zzInterpBrace start=/{[A-Za-z0-9_(]/
      \ end=/}/ contained
      \ contains=zzKeyword,zzBoolean,zzType,zzTypeBuiltin,zzBuiltin,
      \ zzModule,zzDecorator,zzOperator,zzDelimiter,
      \ zzInt,zzFloat,zzString,zzStringTriple,zzEscape,zzVariant,zzFuncName

" ── Numbers (float first; _ separators; no 0x/exp — lexer has none) ───────
syn match zzFloat /\d\(_\?\d\)*\.\d\(_\?\d\)*/
syn match zzInt /\d\(_\?\d\)*/

" ── Definitions ───────────────────────────────────────────────────────────
syn keyword zzFuncDef func nextgroup=zzFuncName skipwhite
syn match zzFuncName /\w\+\%(\.\w\+\)*/ contained
syn keyword zzStructDef struct nextgroup=zzStructName skipwhite
syn match zzStructName /\w\+/ contained
syn keyword zzImplDef impl nextgroup=zzStructName skipwhite
syn keyword zzConstDef const nextgroup=zzConstName skipwhite
syn match zzConstName /\w\+/ contained

" ── Type annotation (name: type) ───────────────────────────────────────────
syn match zzTypeAnnot /\w\+\ze\s*:\s*\w/ containedin=ALLBUT,zzString,zzStringTriple,zzComment,zzInterp,zzInterpTriple

" ── Variant constructors (.ok .err .some .none + user variants) ───────────
" After operators so `.ok` wins over `.` + ident; `..` range matched first.
syn match zzVariant /\.\w\+/

" ── Linking ───────────────────────────────────────────────────────────────
hi def link zzKeyword        Keyword
hi def link zzImportKw       Keyword
hi def link zzImportPath     zzModule
hi def link zzImportAs        Keyword
hi def link zzImportAlias    Identifier
hi def link zzImportName     Function
hi def link zzBoolean        Boolean
hi def link zzType           Type
hi def link zzTypeBuiltin    Type
hi def link zzBuiltin        Function
hi def link zzStdFunc        Function
hi def link zzStdFuncOp      Function
hi def link zzModule         Include
hi def link zzDecorator       PreProc
hi def link zzOperator       Operator
hi def link zzDelimiter      Delimiter
hi def link zzString         String
hi def link zzStringTriple   String
hi def link zzInterp         Normal
hi def link zzInterpTriple   Normal
hi def link zzInterpBrace    Special
hi def link zzEscape         SpecialChar
hi def link zzBraceEscape    SpecialChar
hi def link zzFloat          Float
hi def link zzInt            Number
hi def link zzComment        Comment
hi def link zzTodo           Todo
hi def link zzVariant        Constant
hi def link zzFuncDef        Keyword
hi def link zzFuncName       Function
hi def link zzStructDef      Keyword
hi def link zzStructName     Type
hi def link zzImplDef        Keyword
hi def link zzConstDef       Keyword
hi def link zzConstName       Constant
hi def link zzTypeAnnot      Special

let b:current_syntax = "zz"
