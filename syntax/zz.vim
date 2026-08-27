" zz-lang.nvim — syntax highlighting for ZZ
"
" Full syntax highlighting for the ZZ programming language.
" Supports keywords, types, operators, strings with interpolation,
" comments (line, hash, block), number literals, and variant patterns.

if exists("b:current_syntax")
  finish
endif

" ── Comments ──────────────────────────────────────────────────────────────

" Line comments: // and #
syn match zzComment "//.*$" contains=@Spell
syn match zzComment "#.*$" contains=@Spell

" Block comments: /* ... */ (nestable)
syn region zzComment start="/\*" end="\*/" contains=zzComment fold

" ── Keywords ──────────────────────────────────────────────────────────────

syn keyword zzKeyword
      \ import as func return if else while match
      \ struct for in break continue defer

syn keyword zzBoolean true false

" ── Types ─────────────────────────────────────────────────────────────────

" Primitive types
syn keyword zzType int float bool str

" Generic type constructors (Option<T>, Result<T, E>)
syn match zzTypeGeneric /\v<%(Option|Result)>/ nextgroup=zzTypeAngle
syn match zzTypeAngle /</ nextgroup=zzType contained
syn match zzTypeAngle />/ contained

" ── Operators ─────────────────────────────────────────────────────────────

" Arithmetic
syn match zzOperator /\*\*/
syn match zzOperator /[+\-*/%]/

" Comparison
syn match zzOperator /[!=]=/
syn match zzOperator /[<>]=\?/

" Logical
syn match zzOperator /&&\|||/
syn match zzOperator /!/

" Special operators
syn match zzOperator /??/
syn match zzOperator /?/
syn match zzOperator /:=/
syn match zzOperator /[=]/
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

" String with interpolation support
syn region zzString
      \ start=/"/ end=/"/
      \ contains=zzInterp,zzEscape
      \ oneline

" String interpolation: {expr} inside strings
syn region zzInterp
      \ matchgroup=zzInterpBrace start=/{/ end=/}/
      \ contains=TOP
      \ contained

" Escape sequences
syn match zzEscape /\\[ntr\\"]/ contained

" ── Numbers ───────────────────────────────────────────────────────────────

" Float must come before int to match first
syn match zzFloat /\d\+\.\d\+/
syn match zzInt /\d\+\(_\d\+\)*/

" ── Variant constructors ─────────────────────────────────────────────────

" .ok, .err, .some, .none, .customVariant etc.
syn match zzVariant /\.\w\+/

" ── Function & Struct definitions ────────────────────────────────────────

" Highlight the name of a function being defined
syn match zzFuncDef /\<func\>\s*\zs\w\+\%(\.\w\+\)*/ contained=zzFuncName
syn match zzFuncDef /\<func\>\s*\zs\w\+\%(\.\w\+\)*/ nextgroup=zzFuncName

" Match the name after func keyword in function definitions
syn region zzFuncName
      \ start=/\<func\>\s\+/ end=/{/me=e-1
      \ contains=zzKeyword,zzFuncNameChar
      \ oneline

" ── Pipeline highlight ───────────────────────────────────────────────────

syn match zzPipe /|>/ containedin=ALL

" ── Linking ───────────────────────────────────────────────────────────────

hi def link zzKeyword        Keyword
hi def link zzBoolean        Boolean
hi def link zzType           Type
hi def link zzTypeGeneric    Type
hi def link zzTypeAngle      Delimiter
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
hi def link zzFuncName       Function

let b:current_syntax = "zz"
