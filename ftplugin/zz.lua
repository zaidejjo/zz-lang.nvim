-- zz-lang.nvim — per-buffer settings for ZZ files

if vim.b.did_zz_ftplugin then
  return
end
vim.b.did_zz_ftplugin = true

local bo = vim.bo
local wo = vim.wo

-- Indentation: 4 spaces (matching ZZ style conventions)
bo.tabstop = 4
bo.shiftwidth = 4
bo.softtabstop = 4
bo.expandtab = true

-- Comment string for gc (native comment toggle)
bo.comments = "://,:///,://!,:/*"
bo.commentstring = "// %s"

-- Folding via syntax (window-local options)
wo.foldmethod = "syntax"
wo.foldlevel = 99
