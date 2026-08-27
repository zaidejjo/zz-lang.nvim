-- zz-lang.nvim — default configuration

local M = {}

---@class ZzConfigLsp
---@field enabled boolean
---@field cmd string[]
---@field root_markers string[]
---@field capabilities table|nil
---@field on_attach fun(client: table, bufnr: integer)|nil

---@class ZzConfigFormat
---@field on_save boolean
---@field uses_lsp boolean

---@class ZzConfigCommands
---@field ZZRun boolean
---@field ZZCheck boolean
---@field ZZFmt boolean

---@class ZzConfigSnippets
---@field enabled boolean

---@class ZzConfigStatusline
---@field enabled boolean

---@class ZzConfig
---@field lsp ZzConfigLsp
---@field format ZzConfigFormat
---@field commands ZzConfigCommands
---@field snippets ZzConfigSnippets
---@field statusline ZzConfigStatusline

M.defaults = {
  lsp = {
    enabled = true,
    cmd = { "zz-lsp" },
    root_markers = { ".git", "*.zz" },
    capabilities = nil,
    on_attach = nil,
  },

  format = {
    on_save = true,
    uses_lsp = true,
  },

  commands = {
    ZZRun = true,
    ZZCheck = true,
    ZZFmt = true,
  },

  snippets = {
    enabled = true,
  },

  statusline = {
    enabled = false,
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
