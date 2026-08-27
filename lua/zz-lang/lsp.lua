-- zz-lang.nvim — LSP client setup via vim.lsp
--
-- Uses vim.lsp.start() (Neovim 0.8+) for a built-in, zero-dependency
-- language server connection.  No nvim-lspconfig required.
--
-- Automatically merges capabilities from nvim-cmp or blink.cmp if
-- those plugins are installed.

local M = {}

---@type integer|nil  Client ID returned by vim.lsp.start().
local client_id = nil

---Merge completion plugin capabilities into the base capabilities.
---Detects nvim-cmp and blink.cmp and picks up their
---`get_lsp_capabilities()` output if available.
---@param base table
---@return table
local function merge_completion_capabilities(base)
  local caps = vim.deepcopy(base)

  -- nvim-cmp
  local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp and cmp_lsp.default_capabilities then
    local cmp_caps = cmp_lsp.default_capabilities()
    caps = vim.lsp.protocol.capabilities
      and vim.tbl_deep_extend("force", caps, cmp_caps)
      or cmp_caps
  end

  -- blink.cmp
  local ok_blink, blink_lsp = pcall(require, "blink.cmp")
  if ok_blink and blink_lsp.get_lsp_capabilities then
    local blink_caps = blink_lsp.get_lsp_capabilities()
    caps = vim.tbl_deep_extend("force", caps, blink_caps)
  end

  return caps
end

---Default LSP keymaps attached to a buffer when the zz-lsp client attaches.
---@param bufnr integer
local function setup_keymaps(bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = "ZZ: " .. desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "go to declaration")
  map("n", "gr", vim.lsp.buf.references, "find references")
  map("n", "gi", vim.lsp.buf.implementation, "go to implementation")
  map("n", "K", vim.lsp.buf.hover, "hover documentation")
  map("n", "<leader>rn", vim.lsp.buf.rename, "rename symbol")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "code action")
  map("n", "<C-k>", vim.lsp.buf.signature_help, "signature help")
  map("i", "<C-k>", vim.lsp.buf.signature_help, "signature help")
  map("n", "<leader>f", function() vim.lsp.buf.format({ bufnr = bufnr }) end, "format")

  -- Diagnostic navigation
  map("n", "]d", vim.diagnostic.goto_next, "next diagnostic")
  map("n", "[d", vim.diagnostic.goto_prev, "prev diagnostic")
  map("n", "<leader>dl", vim.diagnostic.open_float, "line diagnostics")
end

---on_attach callback — called when zz-lsp attaches to a buffer.
---@param ev table LspAttach event data.
local function on_attach(ev)
  local bufnr = ev.buf
  setup_keymaps(bufnr)
  vim.diagnostic.enable(bufnr)
end

---Start (or re-use) the zz-lsp language server.
---@param config ZzConfig
function M.start(config)
  local root_dir = vim.fn.getcwd()

  -- Build capabilities with completion plugin support
  local base_caps = config.lsp.capabilities
    or vim.lsp.protocol.make_client_capabilities()
  local capabilities = merge_completion_capabilities(base_caps)

  -- Ensure textDocument/completion is enabled
  if capabilities.textDocument then
    capabilities.textDocument.completion = capabilities.textDocument.completion or {
      completionItem = {
        snippetSupport = true,
        resolveSupport = {
          properties = { "documentation", "detail", "additionalTextEdits" },
        },
      },
    }
  end

  local lsp_config = {
    name = "zz-lsp",
    cmd = config.lsp.cmd,
    root_dir = root_dir,
    capabilities = capabilities,
    on_attach = on_attach,
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
function M.get_client_id()
  return client_id
end

return M
