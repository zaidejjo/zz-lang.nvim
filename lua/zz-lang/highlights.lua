-- nvim-zz — highlight palette
--
-- Gives every ZZ category its own color instead of inheriting one
-- purple `Function` group for everything:
--
--   modules/namespaces ..... teal      (zzModule, @lsp.type.namespace)
--   functions/methods ...... blue      (zzFuncName, @lsp.type.function/.method)
--   builtins (println…) ..... yellow   (zzBuiltin)
--   types/structs .......... green     (zzType*, zzStructName, @lsp.type.*)
--   consts/variants ........ orange    (zzConstName, zzVariant)
--   parameters ............. red italic(zzParam via @lsp.type.parameter)
--
-- Strings, numbers, keywords and comments keep the colorscheme's own
-- groups. Disable with `highlight = { palette = false }` (plain
-- colorscheme links), override single colors with
-- `highlight = { colors = { ZzModule = { fg = "#ff0000" } } }`.

local M = {}

---Default palette: highlight group → definition.
M.defaults = {
  -- Regex syntax groups.
  zzModule = { fg = "#56B6C2" },
  zzFuncName = { fg = "#61AFEF" },
  zzBuiltin = { fg = "#E5C07B" },
  zzStdFunc = { fg = "#61AFEF" },
  zzType = { fg = "#98C379" },
  zzTypeBuiltin = { fg = "#98C379" },
  zzStructName = { fg = "#98C379" },
  zzConstName = { fg = "#D19A66" },
  zzVariant = { fg = "#D19A66" },
  zzDecorator = { fg = "#5C6370" },
  -- Server semantic tokens (0.10+).
  ["@lsp.type.namespace"] = { fg = "#56B6C2" },
  ["@lsp.type.function"] = { fg = "#61AFEF" },
  ["@lsp.type.method"] = { fg = "#61AFEF" },
  ["@lsp.type.struct"] = { fg = "#98C379" },
  ["@lsp.type.type"] = { fg = "#98C379" },
  ["@lsp.type.parameter"] = { fg = "#E06C75", italic = true },
  ["@lsp.type.decorator"] = { fg = "#5C6370" },
  ["@lsp.type.variable"] = { fg = "#A9B1D6" },
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

---Apply highlight groups from a color table.
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
