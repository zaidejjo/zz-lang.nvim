-- nvim-zz — :ZZUpdateServer
--
-- Rebuilds zz-lsp from the local zz_lang checkout, installs it over the
-- binary Neovim actually spawns, and restarts the client — so a stale
-- server (white variables, phantom diagnostics) becomes a one-command
-- fix instead of a debugging session.
--
-- Source dir resolution: `lsp.source_dir` → $ZZ_LANG_ROOT →
-- ~/Projects/zz_lang. Install dir: `lsp.install_dir` → dirname of the
-- `zz-lsp` in $PATH → ~/.zz/bin.
--
-- The install uses write-to-.new + rename (never truncate-in-place):
-- renaming over a running executable is safe on Linux, while `cp`
-- onto it fails with ETXTBSY.

local M = {}

---Resolve the zz_lang checkout dir, or nil with a reason.
---@param config ZzConfig
---@return string|nil, string|nil
function M.resolve_source(config)
  local candidates = {}
  if config.lsp.source_dir and config.lsp.source_dir ~= "" then
    candidates[#candidates + 1] = config.lsp.source_dir
  end
  local env = vim.fn.getenv("ZZ_LANG_ROOT")
  if env and env ~= "" and env ~= vim.NIL then
    candidates[#candidates + 1] = env
  end
  candidates[#candidates + 1] = vim.fn.expand("~/Projects/zz_lang")
  for _, dir in ipairs(candidates) do
    if vim.fn.filereadable(dir .. "/crates/zz_lsp/Cargo.toml") == 1 then
      return dir, nil
    end
  end
  return nil, "no zz_lang checkout found (tried: " .. table.concat(candidates, ", ") .. ")"
end

---Resolve the install dir for the built binary.
---@param config ZzConfig
---@return string
function M.resolve_install_dir(config)
  if config.lsp.install_dir and config.lsp.install_dir ~= "" then
    return config.lsp.install_dir
  end
  local exe = vim.fn.exepath("zz-lsp")
  if exe and exe ~= "" then
    return vim.fn.fnamemodify(exe, ":h")
  end
  return vim.fn.expand("~/.zz/bin")
end

---Compare `zz --version` vs `zz-lsp --version`; warn once on drift.
---Called at startup so a stale server is visible immediately.
function M.check_drift()
  if vim.fn.executable("zz") ~= 1 or vim.fn.executable("zz-lsp") ~= 1 then
    return
  end
  local cli = (vim.fn.systemlist("zz --version")[1] or ""):match("(%d+%.%d+%.%d+)")
  local srv = (vim.fn.systemlist("zz-lsp --version")[1] or ""):match("(%d+%.%d+%.%d+)")
  if cli and srv and cli ~= srv then
    vim.notify(
      ("zz-lang: zz-lsp %s predates zz CLI %s — run :ZZUpdateServer, then :LspRestart"):format(srv, cli),
      vim.log.levels.WARN
    )
  elseif not srv then
    vim.notify("zz-lang: zz-lsp answers no --version (predates 0.1.6) — run :ZZUpdateServer", vim.log.levels.WARN)
  end
end

---Rebuild, install, and restart the server.
---@param config ZzConfig
function M.update(config)
  local src, err = M.resolve_source(config)
  if not src then
    vim.notify("zz-lang: " .. err, vim.log.levels.ERROR)
    return
  end
  local dest_dir = M.resolve_install_dir(config)
  if vim.fn.isdirectory(dest_dir) ~= 1 then
    vim.notify("zz-lang: install dir missing: " .. dest_dir, vim.log.levels.ERROR)
    return
  end
  local staged = dest_dir .. "/zz-lsp.new"
  local final = dest_dir .. "/zz-lsp"
  vim.notify("zz-lang: building zz-lsp from " .. src .. " …", vim.log.levels.INFO)
  vim.fn.jobstart({ "cargo", "build", "--release", "-p", "zz_lsp" }, {
    cwd = src,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.schedule(function()
          vim.notify("zz-lang: build failed (exit " .. code .. ") — see :messages", vim.log.levels.ERROR)
        end)
        return
      end
      local built = src .. "/target/release/zz-lsp"
      vim.schedule(function()
        -- Stage beside the target, then atomic rename over it.
        local ok, msg = pcall(function()
          assert(vim.loop.fs_copyfile(built, staged), "copy failed")
          assert(os.rename(staged, final), "rename failed")
        end)
        if not ok then
          vim.notify("zz-lang: install failed: " .. tostring(msg), vim.log.levels.ERROR)
          return
        end
        vim.notify("zz-lang: zz-lsp installed to " .. final .. " — restarting clients", vim.log.levels.INFO)
        for _, client in ipairs(vim.lsp.get_clients({ name = "zz-lsp" })) do
          vim.lsp.stop_client(client.id, true)
        end
        require("zz-lang.lsp").start(config)
      end)
    end,
  })
end

return M
