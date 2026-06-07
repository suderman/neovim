-- plugin/quickfix.lua
if vim.g.did_load_quickfix_plugin then
	return
end
vim.g.did_load_quickfix_plugin = true

-- Quicker.nvim
require("quicker").setup({
	keys = {
		{
			">",
			function()
				require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
			end,
			desc = "Expand quickfix context",
		},
		{
			"<",
			function()
				require("quicker").collapse()
			end,
			desc = "Collapse quickfix context",
		},
	},
})

-- Quickfix keymaps
vim.keymap.set("n", "<leader>qq", function()
	require("quicker").toggle()
end, { desc = "Toggle quickfix" })

vim.keymap.set("n", "<leader>ql", function()
	require("quicker").toggle({ loclist = true })
end, { desc = "Toggle loclist" })

-- Add current position to quickfix
vim.keymap.set("n", "gq", function()
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
end, { desc = "Append current position to quickfix" })
