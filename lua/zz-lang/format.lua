-- lua/zz-lang/format.lua

local M = {}

local config = nil

function M.format(opts)
	opts = opts or {}
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)

	if config and config.format.uses_lsp then
		local lsp_ok, err = pcall(vim.lsp.buf.format, {
			bufnr = bufnr,
			async = opts.async or false,
			filter = function(client)
				return client.name == "zz-lsp"
			end,
		})
		if lsp_ok then
			pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
			return true
		end
		vim.notify("zz-lang: LSP formatting unavailable (" .. tostring(err) .. "), trying zz fmt", vim.log.levels.WARN)
	end

	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if filepath == "" then
		vim.notify("zz-lang: no file to format", vim.log.levels.WARN)
		return false
	end

	vim.cmd("write")

	local cmd = string.format("zz fmt %s", vim.fn.shellescape(filepath))
	local result = vim.fn.system(cmd)
	local exit_code = vim.v.shell_error

	if exit_code ~= 0 then
		vim.notify("zz-lang: zz fmt failed\n" .. result, vim.log.levels.ERROR)
		return false
	end

	vim.cmd("edit!")
	pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
	return true
end

function M.enable_autosave(cfg)
	config = cfg
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*.zz",
		group = vim.api.nvim_create_augroup("zz_lang_format", { clear = true }),
		callback = function()
			M.format({ async = false })
		end,
		desc = "ZZ: format on save",
	})
end

return M
