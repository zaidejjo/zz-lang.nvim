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
      \ import as func return if else while match
      \ struct for in break continue defer
      \ pub impl const extern

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
syn match zzModule
      \ /\<\(std\|str\|vec\|bytes\|json\|http\|fs\|file\|path\|env\|math\|time\|encoding\|net\|chan\|task\|regexp\|crypto\|log\|span\|sys\|args\|process\|uuid\|sqlz\|db\|colors\|term\|test\|map\|set\|dec\|csv\|option\|result\|File\|ArgsParser\|Regexp\)\./

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
" `{{` and `}}` stay literal (highlighted as escapes); only {ident (+
" {digit / {( in triple strings) interpolates.
syn match zzEscape /\\[ntr\\"{}e]/ contained
syn match zzEscape /\\x\x\{2}/ contained
syn match zzBraceEscape /{{/ contained
syn match zzBraceEscape /}}/ contained

" Single-line "..." — newline terminates (oneline)
syn region zzString start=/"/ skip=/\\"/ end=/"/ oneline
      \ contains=zzEscape,zzBraceEscape,zzInterp

" Interpolation in "...": { + ident-start only
syn region zzInterp matchgroup=zzInterpBrace start=/{[A-Za-z_]/
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
hi def link zzBoolean        Boolean
hi def link zzType           Type
hi def link zzTypeBuiltin    Type
hi def link zzBuiltin        Function
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
