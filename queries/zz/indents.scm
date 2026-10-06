; nvim-zz — tree-sitter indents for ZZ

; Indent blocks one level
[
  (block)
  (dict_literal)
  (array_literal)
  (tuple_literal)
  (match_expression)
  (triple_string)
] @indent.begin

"}" @indent.end
"]" @indent.end
")" @indent.end

[
  "else"
] @indent.branch

(line_comment) @indent.auto
(block_comment) @indent.auto
