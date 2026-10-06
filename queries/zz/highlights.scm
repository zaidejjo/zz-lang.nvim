; nvim-zz — tree-sitter highlights for ZZ
; Requires the tree-sitter-zz parser (../tree-sitter-zz).

; ── Keywords ──
[
  "import" "as" "func" "return" "if" "else" "while" "match"
  "struct" "for" "in" "defer"
  "pub" "impl" "const" "extern"
] @keyword

(break_statement) @keyword
(continue_statement) @keyword

"true" @boolean
"false" @boolean

; ── Types ──
(primitive_type) @type
(named_type name: (type_identifier) @type)

; ── Functions / structs / consts ──
(function_definition name: (identifier) @function)
(struct_definition name: (type_identifier) @type)
(impl_block name: (type_identifier) @type)
(const_definition name: (identifier) @constant)
(parameter name: (identifier) @variable.parameter)

; ── Calls / fields / variants ──
(call_expression function: (identifier) @function.call)
(call_expression function: (field_expression field: (identifier) @function.method.call))
(field_expression field: (identifier) @property)
(variant) @constant.builtin

; ── Modules ──
(import_statement module: (module_path) @namespace)
(module_path) @namespace

; ── Literals ──
(string) @string
(triple_string) @string
(string_content) @string
(brace_content) @string
(rbrace) @string
(escape_sequence) @string.escape
(interpolation) @none
(interpolation "{") @punctuation.special
(interpolation "}") @punctuation.special
(int_literal) @number
(float_literal) @number.float

; ── Operators / punctuation ──
[
  "+" "-" "*" "**" "/" "%"
  "=" "==" "!=" "<" ">" "<=" ">="
  "&&" "||" "!" "?" "??"
  ":=" ":" "," "." ".." "|" "|>" "->" "=>"
  "&" "^" "~" "<<" ">>"
  "+=" "-=" "*=" "/=" "%=" "**=" "&=" "|=" "^=" "<<=" ">>="
  "@" ";"
] @operator

[
  "(" ")" "[" "]" "{" "}"
] @punctuation.bracket

(decorator) @attribute

; ── Comments ──
(line_comment) @comment
(block_comment) @comment
(
  (line_comment) @comment.documentation
  (#match? @comment.documentation "^///")
)
