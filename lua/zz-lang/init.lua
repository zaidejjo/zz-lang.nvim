-- zz-lang.nvim — plugin entry point
--
-- Usage:
--   require("zz-lang").setup({ lsp = { enabled = true } })

local M = {}

---@type ZzConfig|nil
M.config = nil

---Initialize the plugin.
---@param opts table|nil User configuration overrides.
function M.setup(opts)
  local config = require("zz-lang.config")
  M.config = config.merge(opts or {})

  -- 1. Start LSP
  if M.config.lsp.enabled then
    require("zz-lang.lsp").start(M.config)
  end

  -- 2. Register user commands
  require("zz-lang.commands").register(M.config)

  -- 3. Format-on-save
  if M.config.format.on_save then
    require("zz-lang.format").enable_autosave(M.config)
  end

  -- 4. Snippets
  if M.config.snippets.enabled then
    require("zz-lang.snippets").register()
  end

  -- 5. Statusline (only if enabled — user opts in)
  if M.config.statusline.enabled then
    require("zz-lang.statusline").enable()
  end
end

return M
