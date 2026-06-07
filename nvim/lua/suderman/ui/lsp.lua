local ok_lightbulb, lightbulb = pcall(require, "nvim-lightbulb")
if not ok_lightbulb then
	return
end

lightbulb.setup({
	sign = {
		enabled = true,
		text = "💡",
		texthl = "LightBulbSign",
	},
	virtual_text = { enabled = false },
	float = { enabled = false },
	status_text = { enabled = false },
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	pattern = "*",
	callback = function()
		pcall(lightbulb.update_lightbulb)
	end,
})
