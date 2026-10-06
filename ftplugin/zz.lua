-- nvim-zz — per-buffer settings for ZZ files

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

-- gf on imports: `import std.http` / `import ./lib` jumps to the file.
bo.suffixesadd = ".zz"
bo.include = "^\\s*import\\s\\+"
bo.includeexpr = "v:lua.zz_includeexpr(v:fname)"

---Resolve an import path for gf.
---@param fname string Raw import target.
---@return string Resolved path.
function _G.zz_includeexpr(fname)
  -- std.x -> <zz_lang>/crates/zz_stdlib/zz/x/mod.zz when ZZ_ROOT is set,
  -- otherwise leave it for the default search.
  local mod = fname:match("^std%.([%w_]+)$")
  local root = vim.env.ZZ_ROOT
  if mod and root and root ~= "" then
    local candidate = root .. "/crates/zz_stdlib/zz/" .. mod .. "/mod.zz"
    if vim.fn.filereadable(candidate) == 1 then
      return candidate
    end
  end
  -- Relative imports resolve against the current file's directory.
  if fname:sub(1, 1) == "." then
    return vim.fn.expand("%:p:h") .. "/" .. fname
  end
  return fname
end

-- Completion fallback: dictionary omnifunc until zz-lsp attaches and
-- upgrades it to v:lua.vim.lsp.omnifunc (see lua/zz-lang/lsp.lua).
-- Keeps C-x C-o / <C-Space> useful with no server running.
if vim.bo.omnifunc == "" then
  vim.bo.omnifunc = "v:lua.zz_omnifunc"
end

-- Folding via syntax (window-local options)
wo.foldmethod = "syntax"
wo.foldlevel = 99
