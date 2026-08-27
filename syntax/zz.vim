" zz-lang.nvim — syntax highlighting for ZZ
"
" Full syntax highlighting for the ZZ programming language.
" Supports keywords, types, operators, strings with interpolation,
" comments (line, hash, block), number literals, and variant patterns.

if exists("b:current_syntax")
  finish
endif

" ── Comments ──────────────────────────────────────────────────────────────

" Line comments: // and # (defined after operators so they win)
syn match zzComment "//.*" contains=@Spell
syn match zzComment "#.*" contains=@Spell

" Block comments: /* ... */ (nestable)
syn region zzComment start="/\*" end="\*/" contains=zzComment fold

" ── Keywords ──────────────────────────────────────────────────────────────

syn keyword zzKeyword
      \ import as func return if else while match
      \ struct for in break continue defer

syn keyword zzBoolean true false

" ── Types ─────────────────────────────────────────────────────────────────

" Primitive types (must come BEFORE builtins to take priority)
syn keyword zzType int float bool str

" Generic type constructors (Option<T>, Result<T, E>)
syn keyword zzTypeBuiltin Option Result

" ── Built-in functions ────────────────────────────────────────────────────

" Top-level builtins (no import required) - NO type names here!
syn keyword zzBuiltin print println input
      \ len map filter enumerate zip range
      \ typeof
      \ assert panic

" ── Operators ─────────────────────────────────────────────────────────────

" Arithmetic (split / to avoid matching // comments)
syn match zzOperator /\*\*/
syn match zzOperator /[+\-*%]/
syn match zzOperator /\/\@!/

" Comparison
syn match zzOperator /[!=]=/
syn match zzOperator /[<>]=\?/

" Logical
syn match zzOperator /&&\|||/
syn match zzOperator /!/

" Special operators (order matters: longer first)
syn match zzOperator /??/
syn match zzOperator /:=/
syn match zzOperator /=/
syn match zzOperator /->/
syn match zzOperator /=>/
syn match zzOperator /\.\./
syn match zzOperator /|>/
syn match zzOperator /|/

" ── Delimiters ────────────────────────────────────────────────────────────

syn match zzDelimiter /[()]/
syn match zzDelimiter /[{}]/
syn match zzDelimiter /[[\]]/

" ── Strings ───────────────────────────────────────────────────────────────

" Escape sequences (must be defined before strings so they're contained)
syn match zzEscape /\\[ntr\\"]/ contained

" String with interpolation support
syn region zzString start=/"/ end=/"/ oneline contains=zzEscape,zzInterp

" String interpolation: {expr} inside strings
syn region zzInterp matchgroup=zzInterpBrace start=/{/ end=/}/ contains=@Spell,zzKeyword,zzBoolean,zzType,zzBuiltin,zzOperator,zzInt,zzFloat,zzString,zzEscape contained

" ── Numbers ───────────────────────────────────────────────────────────────

" Float must come before int to match first
syn match zzFloat /\d\+\.\d\+/
syn match zzInt /\d\+\(_\d\+\)*/

" ── Function definitions ─────────────────────────────────────────────────

" func keyword
syn keyword zzFuncDef func nextgroup=zzFuncName skipwhite

" Function name after `func` keyword
syn match zzFuncName /\w\+\%(\.\w\+\)*/ contained

" ── Struct definitions ────────────────────────────────────────────────────

syn keyword zzStructDef struct nextgroup=zzStructName skipwhite
syn match zzStructName /\w\+\%(\.\w\+\)*/ contained

" ── Type annotation (name: type = value) ─────────────────────────────────
" Match `ident:` pattern for explicit type annotations.
syn match zzTypeAnnot /\w\+\ze\s*:\s*\w/ containedin=ALLBUT,zzString,zzComment

" ── Variant constructors ─────────────────────────────────────────────────
" DEFINED LAST to take priority over operators (e.g., .ok vs .. range)
syn match zzVariant /\.\w\+/

" ── Pipeline highlight ───────────────────────────────────────────────────

syn match zzPipe /|>/ containedin=ALL

" ── Linking ───────────────────────────────────────────────────────────────

hi def link zzKeyword        Keyword
hi def link zzBoolean        Boolean
hi def link zzType           Type
hi def link zzTypeBuiltin    Type
hi def link zzBuiltin        Function
hi def link zzOperator       Operator
hi def link zzDelimiter      Delimiter
hi def link zzString         String
hi def link zzInterpBrace    Special
hi def link zzEscape         Special
hi def link zzFloat          Float
hi def link zzInt            Number
hi def link zzComment        Comment
hi def link zzVariant        Constant
hi def link zzPipe           Operator
hi def link zzFuncDef        Keyword
hi def link zzFuncName       Function
hi def link zzStructDef      Keyword
hi def link zzStructName     Type
hi def link zzTypeAnnot      Special

let b:current_syntax = "zz"