-- nvim-zz — ready lazy.nvim spec.
-- Copy to ~/.config/nvim/lua/plugins/zz.lua (or require it from init.lua).

return {
  "zz-language/nvim-zz",
  ft = "zz",
  config = function()
    require("zz-lang").setup({
      -- format = { on_save = false }, -- stop format-on-save
      -- lsp = { cmd = { "zz-lsp" } }, -- custom server command/path
      -- statusline = { enabled = true }, -- lualine component (see README)
    })
  end,
}
