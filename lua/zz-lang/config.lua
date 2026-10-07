-- nvim-zz — default configuration

local M = {}

---@class ZzConfigLsp
---@field enabled boolean
---@field cmd string[]
---@field root_markers string[]
---@field capabilities table|nil
---@field on_attach fun(client: table, bufnr: integer)|nil
---@field inlay_hints boolean Enable inlay hints when the server offers them
---@field source_dir string|nil zz_lang checkout for :ZZUpdateServer (default: $ZZ_LANG_ROOT or ~/Projects/zz_lang)
---@field install_dir string|nil where :ZZUpdateServer installs zz-lsp (default: dir of the zz-lsp in $PATH)

---@class ZzConfigFormat
---@field on_save boolean
---@field uses_lsp boolean

---@class ZzConfigCommands
---@field ZZRun boolean
---@field ZZCheck boolean
---@field ZZFmt boolean
---@field ZZTest boolean
---@field ZZBuild boolean
---@field ZZDoc boolean
---@field ZZUpdateServer boolean

---@class ZzConfigSnippets
---@field enabled boolean

---@class ZzConfigStatusline
---@field enabled boolean

---@class ZzConfigHighlight
---@field semantic_tokens boolean Compiler-driven colors (namespaces, fns, types) via LSP
---@field references boolean Highlight symbol references under the cursor
---@field palette boolean Distinct ZZ color palette (disable for plain theme links)
---@field colors table<string, table> Per-group highlight overrides

---@class ZzConfig
---@field lsp ZzConfigLsp
---@field format ZzConfigFormat
---@field commands ZzConfigCommands
---@field snippets ZzConfigSnippets
---@field statusline ZzConfigStatusline
---@field highlight ZzConfigHighlight

M.defaults = {
  lsp = {
    enabled = true,
    cmd = { "zz-lsp" },
    root_markers = { "zz.toml", ".git" },
    capabilities = nil,
    on_attach = nil,
    inlay_hints = true,
    source_dir = nil,
    install_dir = nil,
  },

  format = {
    on_save = true,
    uses_lsp = true,
  },

  commands = {
    ZZRun = true,
    ZZCheck = true,
    ZZFmt = true,
    ZZTest = true,
    ZZBuild = true,
    ZZDoc = true,
    ZZUpdateServer = true,
  },

  snippets = {
    enabled = true,
  },

  statusline = {
    enabled = false,
  },

  highlight = {
    semantic_tokens = true,
    references = true,
    palette = true,
    colors = {},
  },
}

---Deep-merge two tables, with `b` overriding `a`.
---@param a table
---@param b table
---@return table
function M.deep_merge(a, b)
  local result = vim.deepcopy(a)
  for k, v in pairs(b) do
    if type(v) == "table" and type(result[k]) == "table" then
      result[k] = M.deep_merge(result[k], v)
    else
      result[k] = vim.deepcopy(v)
    end
  end
  return result
end

---Merge user opts with defaults.
---@param opts table|nil
---@return ZzConfig
function M.merge(opts)
  return M.deep_merge(M.defaults, opts or {})
end

return M
