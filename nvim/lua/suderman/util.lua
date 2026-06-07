-- suderman util.lua
local M = {}

-- Toggle autoformat
function M.toggle_format()
	vim.b.disableFormatSave = not vim.b.disableFormatSave
	print("Autoformat: " .. (vim.b.disableFormatSave and "disabled" or "enabled"))
end

-- Add current position to quickfix
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

-- Local config loader
-- Loads optional local config from ~/.config/nvim/lua/local/init.lua
function M.load_local_config()
	local dir = vim.fn.expand("~/.config/nvim/lua/local")
	local file = dir .. "/init.lua"

	if vim.fn.filereadable(file) == 0 then
		-- Don't create the file automatically; just skip loading
		return
	end
	-- Use pcall in case the module has errors or doesn't exist
	pcall(require, "local")
end

return M
