-- zz-lang.nvim — statusline / lualine integration
--
-- Provides a lightweight statusline component that shows ZZ LSP status.
-- Works with lualine.nvim or any statusline that accepts a function.

local M = {}

---@type boolean
M._enabled = false

---Mark the module as enabled (called from init.lua).
function M.enable()
  M._enabled = true
end

---Get a statusline string for the current buffer.
---@return string
function M.status()
  if not M._enabled then
    return ""
  end

  -- Only show for zz buffers
  local ft = vim.bo.filetype
  if ft ~= "zz" then
    return ""
  end

  -- Count diagnostics
  local diagnostics = vim.diagnostic.get(0)
  local errors = 0
  local warnings = 0
  for _, d in ipairs(diagnostics) do
    if d.severity == vim.diagnostic.severity.ERROR then
      errors = errors + 1
    elseif d.severity == vim.diagnostic.severity.WARN then
      warnings = warnings + 1
    end
  end

  -- LSP client status
  local clients = vim.lsp.get_clients({ name = "zz-lsp", bufnr = 0 })
  local client = clients[1]

  local parts = {}

  -- Base indicator
  if client then
    table.insert(parts, "ZZ")
  else
    table.insert(parts, "ZZ(-)")
  end

  -- Diagnostics
  if errors > 0 then
    table.insert(parts, string.format("E:%d", errors))
  end
  if warnings > 0 then
    table.insert(parts, string.format("W:%d", warnings))
  end

  if #parts == 1 then
    -- No diagnostics, just "ZZ"
    return parts[1]
  end

  return table.concat(parts, " ")
end

---Lualine-compatible component.
---Use in your lualine config:
---  sections = {
---    lualine_x = { require("zz-lang.statusline").lualine_component() },
---  }
---@return table
function M.lualine_component()
  return {
    function()
      return M.status()
    end,
    cond = function()
      return vim.bo.filetype == "zz"
    end,
    color = function()
      local diagnostics = vim.diagnostic.get(0)
      local has_errors = false
      for _, d in ipairs(diagnostics) do
        if d.severity == vim.diagnostic.severity.ERROR then
          has_errors = true
          break
        end
      end
      if has_errors then
        return { fg = "#ff0000", gui = "bold" }
      end
      return { fg = "#98c379" }
    end,
  }
end

return M
