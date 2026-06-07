local M = {}

function M.add_to_quickfix()
	local pos = vim.api.nvim_win_get_cursor(0)
	local file = vim.api.nvim_buf_get_name(0)

	if file == "" then
		print("No file name available.")
		return
	end

	vim.fn.setqflist({
		{
			filename = file,
			lnum = pos[1],
			col = pos[2] + 1,
			text = vim.fn.getline("."),
		},
	}, "a")

	print(string.format("Added to quickfix: %s:%d", file, pos[1]))
end

function M.toggle_quickfix()
	for _, win in pairs(vim.fn.getwininfo() or {}) do
		if win.quickfix == 1 then
			vim.cmd.cclose()
			return
		end
	end

	if not vim.tbl_isempty(vim.fn.getqflist()) then
		vim.cmd.copen()
	end
end

function M.load_local_config()
	local dir = vim.fn.expand("~/.config/nvim/lua/local")
	local file = dir .. "/init.lua"

	if vim.fn.filereadable(file) == 0 then
		return
	end

	pcall(require, "local")
end

return M
