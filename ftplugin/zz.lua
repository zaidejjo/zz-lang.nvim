-- zz-lang.nvim — per-buffer settings for ZZ files

if vim.b.did_zz_ftplugin then
  return
end
vim.b.did_zz_ftplugin = true

local bo = vim.bo

-- Indentation: 4 spaces (matching ZZ style conventions)
bo.tabstop = 4
bo.shiftwidth = 4
bo.softtabstop = 4
bo.expandtab = true

-- Comment string for gc (native comment toggle)
bo.comments = "://,:///,://!,://"
bo.commentstring = "// %s"

-- Folding via syntax
bo.foldmethod = "syntax"
bo.foldlevel = 99

-- Keyword lookup: K jumps to help, or here we can define local keyword
-- Check if `zz run --help` is available for :help zz
if vim.fn.exists(":ZZRun") == 2 then
  vim.keymap.set("n", "K", function()
    vim.cmd("help zz-lang")
  end, { buffer = true, silent = true, desc = "ZZ help" })
end
