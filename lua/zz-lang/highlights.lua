-- nvim-zz — highlight palette
--
-- Theme-first colors: every ZZ group links to a standard theme group, so
-- any colorscheme instantly gives a coherent, distinct look with zero
-- hardcoded hexes:
--
--   modules/namespaces ..... Include     (zzModule, @lsp.type.namespace)
--   functions/methods ...... Function    (zzFuncName, zzStdFunc, @lsp.type.function/.method)
--   builtins (println…) ..... Special     (zzBuiltin)
--   types/structs .......... Type        (zzType*, zzStructName, @lsp.type.struct/.type)
--   consts/variants ........ Constant    (zzConstName, zzVariant)
--   parameters ............. Special     (@lsp.type.parameter)
--   variables .............. Identifier  (@lsp.type.variable)
--   decorators ............. PreProc     (zzDecorator)
--
-- Server semantic tokens link back to the same zz groups, so regex and
-- compiler-driven colors always agree — one group to tweak per category.
--
-- Change a single color (replaces that group's link):
--   highlight = { colors = { zzModule = { fg = "#ff0000" } } }
-- Disable everything (plain syntax defaults):
--   highlight = { palette = false }

local M = {}

---Default palette: highlight group → link target.
M.defaults = {
  -- Regex syntax groups.
  zzModule = { link = "Include" },
  zzFuncName = { link = "Function" },
  zzBuiltin = { link = "Special" },
  zzStdFunc = { link = "Function" },
  zzType = { link = "Type" },
  zzTypeBuiltin = { link = "Type" },
  zzStructName = { link = "Type" },
  zzConstName = { link = "Constant" },
  zzVariant = { link = "Constant" },
  zzDecorator = { link = "PreProc" },
  -- Server semantic tokens (0.10+): follow the zz groups above.
  ["@lsp.type.namespace"] = { link = "zzModule" },
  ["@lsp.type.function"] = { link = "zzFuncName" },
  ["@lsp.type.method"] = { link = "zzFuncName" },
  ["@lsp.type.struct"] = { link = "zzStructName" },
  ["@lsp.type.type"] = { link = "zzType" },
  ["@lsp.type.parameter"] = { link = "Special" },
  ["@lsp.type.variable"] = { link = "Identifier" },
  ["@lsp.type.decorator"] = { link = "zzDecorator" },
}

---Plain colorscheme links used when the palette is disabled.
M.links = {
  zzModule = "Include",
  zzFuncName = "Function",
  zzBuiltin = "Function",
  zzStdFunc = "Function",
  zzType = "Type",
  zzTypeBuiltin = "Type",
  zzStructName = "Type",
  zzConstName = "Constant",
  zzVariant = "Constant",
  zzDecorator = "PreProc",
}

---Apply highlight groups from a spec table.
---@param colors table<string, table>
local function apply(colors)
  for group, spec in pairs(colors) do
    pcall(vim.api.nvim_set_hl, 0, group, spec)
  end
end

---Apply links for palette-off mode.
local function apply_links()
  for group, target in pairs(M.links) do
    pcall(vim.api.nvim_set_hl, 0, group, { link = target })
  end
end

---Set up highlighting.
---@param config ZzConfig
function M.setup(config)
  local hl = config.highlight or {}
  if hl.palette == false then
    apply_links()
    return
  end
  local colors = vim.deepcopy(M.defaults)
  for group, spec in pairs(hl.colors or {}) do
    colors[group] = spec
  end
  apply(colors)

  -- Colorschemes wipe custom highlights; re-apply after any change.
  local aug = vim.api.nvim_create_augroup("zz_lang_highlight", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = aug,
    callback = function()
      apply(colors)
    end,
    desc = "ZZ: re-apply palette after colorscheme change",
  })
end

return M
