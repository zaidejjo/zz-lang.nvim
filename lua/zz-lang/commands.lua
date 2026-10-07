-- nvim-zz — user commands
--
-- :ZZRun    — run current file with `zz run`
-- :ZZCheck  — type-check current file with `zz check`
-- :ZZFmt    — format current file with `zz fmt` or LSP
-- :ZZTest   — run tests with `zz test`
-- :ZZBuild  — compile current file with `zz build`

local M = {}

local function current_file_or_warn()
  local filepath = vim.fn.expand("%:p")
  if filepath == "" then
    vim.notify("zz-lang: no file to run", vim.log.levels.WARN)
    return nil
  end
  return filepath
end

local function run_current_file()
  local filepath = current_file_or_warn()
  if not filepath then
    return
  end
  vim.cmd("terminal zz run " .. vim.fn.shellescape(filepath))
end

local function check_current_file()
  local filepath = current_file_or_warn()
  if not filepath then
    return
  end
  vim.cmd("terminal zz check " .. vim.fn.shellescape(filepath))
end

local function test_current_file()
  local filepath = current_file_or_warn()
  if not filepath then
    return
  end
  vim.cmd("terminal zz test " .. vim.fn.shellescape(filepath))
end

local function build_current_file()
  local filepath = current_file_or_warn()
  if not filepath then
    return
  end
  vim.cmd("terminal zz build " .. vim.fn.shellescape(filepath))
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

  if config.commands.ZZTest then
    vim.api.nvim_create_user_command("ZZTest", test_current_file, {
      desc = "ZZ: test current file",
      nargs = 0,
    })
  end

  if config.commands.ZZBuild then
    vim.api.nvim_create_user_command("ZZBuild", build_current_file, {
      desc = "ZZ: build current file to a native binary",
      nargs = 0,
    })
  end

  if config.commands.ZZDoc then
    vim.api.nvim_create_user_command("ZZDoc", function()
      require("zz-lang.docs").show_cursor()
    end, { desc = "ZZ: stdlib help for word under cursor" })
  end

  if config.commands.ZZUpdateServer then
    vim.api.nvim_create_user_command("ZZUpdateServer", function()
      require("zz-lang.update").update(config)
    end, { desc = "ZZ: rebuild zz-lsp from source, install, restart" })
  end

  -- Always register diagnostic navigation
  vim.api.nvim_create_user_command("ZZDiag", function()
    vim.diagnostic.open_float(0, { scope = "line" })
  end, { desc = "ZZ: show diagnostics at cursor" })

  local _ = group -- suppress unused warning
end

return M
