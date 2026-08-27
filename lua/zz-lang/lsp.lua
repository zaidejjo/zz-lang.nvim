-- zz-lang.nvim — LSP client setup via vim.lsp
--
-- Uses vim.lsp.start() (Neovim 0.8+) for a built-in, zero-dependency
-- language server connection.  No nvim-lspconfig required.

local M = {}

---@type integer|nil  Buffer number the server is attached to (first .zz file opened).
local attached_bufnr = nil

---@type integer|nil  Client ID returned by vim.lsp.start().
local client_id = nil

---Default LSP keymaps attached to a buffer when the zz-lsp client attaches.
---@param bufnr integer
local function setup_keymaps(bufnr)
  local opts = { buffer = bufnr, silent = true }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "ZZ: go to definition" }))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "ZZ: go to declaration" }))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "ZZ: find references" }))
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "ZZ: go to implementation" }))
  vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "ZZ: hover" }))
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "ZZ: rename symbol" }))
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "ZZ: code action" }))
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "ZZ: signature help" }))
  vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "ZZ: signature help" }))

  -- Format on demand
  vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ bufnr = bufnr })
  end, vim.tbl_extend("force", opts, { desc = "ZZ: format" }))
end

---on_attach callback — called when zz-lsp attaches to a buffer.
---@param ev table LspAttach event data.
local function on_attach(ev)
  local bufnr = ev.buf
  setup_keymaps(bufnr)
  -- Publish diagnostics on attach
  vim.diagnostic.enable(bufnr)
end

---Start (or re-use) the zz-lsp language server.
---@param config ZzConfig
function M.start(config)
  -- Resolve root directory from the current working directory.
  local root_dir = vim.fn.getcwd()

  -- Start the LSP client.
  local lsp_config = {
    name = "zz-lsp",
    cmd = config.lsp.cmd,
    root_dir = root_dir,
    capabilities = config.lsp.capabilities or vim.lsp.protocol.make_client_capabilities(),
    on_attach = on_attach,
    -- Request ZZ diagnostics when files change.
    settings = {},
  }

  client_id = vim.lsp.start(lsp_config)

  if client_id then
    -- Attach the current buffer if it's a .zz file.
    local current_ft = vim.bo.filetype
    if current_ft == "zz" then
      vim.lsp.buf_attach_client(0, client_id)
    end

    -- Auto-attach when a .zz file is opened.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "zz",
      callback = function(ev)
        if client_id then
          vim.lsp.buf_attach_client(ev.buf, client_id)
        end
      end,
      desc = "Attach zz-lsp to .zz files",
    })
  end
end

---Get the active client ID (for statusline integration).
---@return integer|nil
function M.client_id()
  return client_id
end

return M
