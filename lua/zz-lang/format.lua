-- zz-lang.nvim — formatting
--
-- Format current buffer via LSP (textDocument/formatting) with a
-- fallback to shelling out to `zz fmt <file>`.

local M = {}

---@type ZzConfig|nil
local config = nil

---Format the current buffer.
---@param opts table|nil  Optional: { async = true/false }.
function M.format(opts)
  opts = opts or {}
  local bufnr = vim.api.nvim_get_current_buf()

  -- 1. Try LSP formatting
  if config and config.format.uses_lsp then
    local lsp_ok, err = pcall(vim.lsp.buf.format, {
      bufnr = bufnr,
      async = opts.async or false,
      filter = function(client)
        return client.name == "zz-lsp"
      end,
    })
    if lsp_ok then
      return true
    end
    -- LSP not available — fall through to zz fmt
    vim.notify("zz-lang: LSP formatting unavailable (" .. tostring(err) .. "), trying zz fmt", vim.log.levels.WARN)
  end

  -- 2. Fallback: shell out to `zz fmt`
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == "" then
    vim.notify("zz-lang: no file to format", vim.log.levels.WARN)
    return false
  end

  local cmd = string.format("zz fmt %s", vim.fn.shellescape(filepath))
  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  if exit_code ~= 0 then
    vim.notify("zz-lang: zz fmt failed\n" .. result, vim.log.levels.ERROR)
    return false
  end

  -- Reload the buffer to pick up the formatted content.
  vim.cmd("edit!")
  return true
end

---Enable format-on-save for zz files.
---@param cfg ZzConfig
function M.enable_autosave(cfg)
  config = cfg
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.zz",
    group = vim.api.nvim_create_augroup("zz_lang_format", { clear = true }),
    callback = function()
      M.format({ async = false })
    end,
    desc = "ZZ: format on save",
  })
end

return M
