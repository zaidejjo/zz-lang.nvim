-- zz-lang.nvim — user commands
--
-- :ZZRun    — run current file with `zz run`
-- :ZZCheck  — type-check current file with `zz check`
-- :ZZFmt    — format current file with `zz fmt` or LSP

local M = {}

local function run_current_file()
  local filepath = vim.fn.expand("%:p")
  if filepath == "" then
    vim.notify("zz-lang: no file to run", vim.log.levels.WARN)
    return
  end
  vim.cmd("terminal zz run " .. vim.fn.shellescape(filepath))
end

local function check_current_file()
  local filepath = vim.fn.expand("%:p")
  if filepath == "" then
    vim.notify("zz-lang: no file to check", vim.log.levels.WARN)
    return
  end
  vim.cmd("terminal zz check " .. vim.fn.shellescape(filepath))
end

local function fmt_current_file()
  require("zz-lang.format").format()
end

---Register all user commands.
---@param config ZzConfig
function M.register(config)
  local group = vim.api.nvim_create_augroup("zz_lang_commands", { clear = true })

  if config.commands.ZZRun then
    vim.api.nvim_create_user_command("ZZRun", run_current_file, {
      desc = "ZZ: run current file",
      nargs = 0,
    })
  end

  if config.commands.ZZCheck then
    vim.api.nvim_create_user_command("ZZCheck", check_current_file, {
      desc = "ZZ: type-check current file",
      nargs = 0,
    })
  end

  if config.commands.ZZFmt then
    vim.api.nvim_create_user_command("ZZFmt", fmt_current_file, {
      desc = "ZZ: format current file",
      nargs = 0,
    })
  end

  -- Always register diagnostic navigation
  vim.api.nvim_create_user_command("ZZDiag", function()
    vim.diagnostic.open_float(0, { scope = "line" })
  end, { desc = "ZZ: show diagnostics at cursor" })

  local _ = group -- suppress unused warning
end

return M
