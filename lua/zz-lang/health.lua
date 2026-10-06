-- nvim-zz — :checkhealth report

local M = {}

function M.check()
  vim.health.start("nvim-zz")

  -- Neovim version (0.8+ for vim.lsp.start, 0.10+ for inlay hints/snippet)
  if vim.fn.has("nvim-0.10") == 1 then
    vim.health.ok("Neovim >= 0.10 (LSP, inlay hints, built-in snippets)")
  elseif vim.fn.has("nvim-0.8") == 1 then
    vim.health.warn("Neovim 0.8–0.9: works, but inlay hints need 0.10+")
  else
    vim.health.error("Neovim >= 0.8 required")
  end

  -- zz CLI
  if vim.fn.executable("zz") == 1 then
    local out = vim.fn.systemlist("zz --version")
    vim.health.ok("zz CLI: " .. (out[1] or "found"))
  else
    vim.health.error("zz CLI not in $PATH (needed for :ZZRun/:ZZCheck/:ZZFmt)")
  end

  -- zz-lsp server
  if vim.fn.executable("zz-lsp") == 1 then
    vim.health.ok("zz-lsp binary in $PATH")
  else
    vim.health.error("zz-lsp not in $PATH (build with: cargo build --release -p zz_lsp)")
  end

  -- Optional completion engines
  local has_cmp = pcall(require, "cmp_nvim_lsp")
  local has_blink = pcall(require, "blink.cmp")
  local has_luasnip = pcall(require, "luasnip")
  if has_cmp or has_blink then
    vim.health.ok("completion engine: " .. (has_cmp and "nvim-cmp " or "") .. (has_blink and "blink.cmp" or ""))
  else
    vim.health.warn("no completion engine (nvim-cmp/blink.cmp) — omnifunc fallback active")
  end
  if has_luasnip then
    vim.health.ok("luasnip: snippets registered")
  else
    vim.health.info("luasnip not found — built-in snippet fallback active")
  end

  -- Tree-sitter parser (optional, enhances highlighting)
  local has_ts = pcall(require, "nvim-treesitter")
  local has_zz_parser = false
  if has_ts then
    local parsers = require("nvim-treesitter.parsers")
    has_zz_parser = parsers.has_parser and parsers.has_parser("zz")
  end
  if has_zz_parser then
    vim.health.ok("tree-sitter zz parser installed")
  else
    vim.health.warn("tree-sitter zz parser not installed (Vim regex highlighting active)")
  end
end

return M
