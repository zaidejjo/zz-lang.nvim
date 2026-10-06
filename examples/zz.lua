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
      -- highlight = { semantic_tokens = false }, -- regex highlighting only
    })

    -- Optional: nvim-cmp buffer source for ZZ files.
    -- (blink.cmp needs no extra wiring — it uses the LSP source.)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "zz",
      callback = function()
        local ok_cmp, cmp = pcall(require, "cmp")
        if ok_cmp then
          cmp.setup.buffer({
            sources = {
              { name = "nvim_lsp" },
              { name = "zz-snippets" },
            },
          })
        end
      end,
      desc = "ZZ: cmp sources",
    })
  end,
}
