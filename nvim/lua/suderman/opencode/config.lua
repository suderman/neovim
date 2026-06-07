local M = {}

local function executable()
	local path = vim.fn.expand("~/.local/bin/opencode")
	if vim.fn.executable(path) == 1 then
		return path
	end
	return "opencode"
end

function M.setup(opencode)
	opencode.setup({
		opencode_executable = executable(),
		preferred_picker = "snacks",
		preferred_completion = "blink",
		default_mode = "mini",
		default_global_keymaps = false,
		keymap = {
			input_window = {
				["<tab>"] = {
					"switch_mode",
					mode = { "n", "i" },
					desc = "Switch agent mode",
					defer_to_completion = true,
				},
				["<M-m>"] = false,
			},
			output_window = {
				["<tab>"] = { "switch_mode", mode = { "n" }, desc = "Switch agent mode" },
			},
		},
	})
end

return M
