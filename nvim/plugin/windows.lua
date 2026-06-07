-- plugin/windows.lua
if vim.g.did_load_windows_plugin then
	return
end
vim.g.did_load_windows_plugin = true

-- Tmux navigator is included via vimPlugins.vim-tmux-navigator in Nix
-- Keymaps are in keymaps.lua

-- Close floating windows
vim.keymap.set("n", "<leader>fq", function()
	vim.cmd("fclose!")
end, { silent = true, desc = "[f]loating windows: [q]uit/close all" })

-- Yank from current position till end of current line
vim.keymap.set("n", "Y", "y$", { silent = true, desc = "[Y]ank to end of line" })

-- Resize vertical/horizontal splits
local function resize_window(operator)
	local cur_size = operator == "width" and vim.api.nvim_win_get_width(0) or vim.api.nvim_win_get_height(0)
	local new_size = math.ceil(cur_size * 3 / 2)
	if operator == "width" then
		vim.api.nvim_win_set_width(0, new_size)
	else
		vim.api.nvim_win_set_height(0, new_size)
	end
end

vim.keymap.set("n", "<leader>w+", function()
	resize_window("width")
end, { silent = true, desc = "Inc window width" })

vim.keymap.set("n", "<leader>w-", function()
	local cur_width = vim.api.nvim_win_get_width(0)
	vim.api.nvim_win_set_width(0, math.floor(cur_width * 2 / 3))
end, { silent = true, desc = "Dec window width" })

vim.keymap.set("n", "<leader>h+", function()
	resize_window("height")
end, { silent = true, desc = "Inc window height" })

vim.keymap.set("n", "<leader>h-", function()
	local cur_height = vim.api.nvim_win_get_height(0)
	vim.api.nvim_win_set_height(0, math.floor(cur_height * 2 / 3))
end, { silent = true, desc = "Dec window height" })

-- Toggle quickfix list
local function toggle_qf_list()
	local qf_exists = false
	for _, win in pairs(vim.fn.getwininfo() or {}) do
		if win.quickfix == 1 then
			qf_exists = true
		end
	end
	if qf_exists then
		vim.cmd.cclose()
		return
	end
	if not vim.tbl_isempty(vim.fn.getqflist()) then
		vim.cmd.copen()
	end
end

vim.keymap.set("n", "<C-c>", toggle_qf_list, { desc = "Toggle quickfix list" })
