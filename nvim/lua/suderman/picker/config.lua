local M = {}

local function picker_action(snacks, source, focus)
	return function(picker)
		picker:close()
		snacks.picker.pick({
			source = source,
			focus = focus,
		})
	end
end

function M.setup(snacks)
	snacks.setup({
		bigfile = { enabled = true },
		dim = {
			animate = { duration = { step = 10, total = 200 } },
			enabled = true,
		},
		image = {
			enabled = true,
			force = true,
			inline = true,
		},
		indent = {
			animate = { duration = { step = 10, total = 200 } },
			enabled = true,
			scope = { enabled = true, hl = "LineNr", underline = true },
		},
		input = { enabled = true },
		notifier = {
			enabled = true,
			level = "INFO",
			style = "minimal",
			top_down = false,
		},
		picker = {
			actions = {
				buffers = picker_action(snacks, "buffers", "list"),
				command_history = picker_action(snacks, "command_history", "list"),
				commands = picker_action(snacks, "commands", "input"),
				diagnostics = picker_action(snacks, "diagnostics", "list"),
				diagnostics_buffer = picker_action(snacks, "diagnostics_buffer", "list"),
				explorer = picker_action(snacks, "explorer", "list"),
				files = picker_action(snacks, "files", "input"),
				grep = picker_action(snacks, "grep", "input"),
				jumps = picker_action(snacks, "jumps", "list"),
				keymaps = picker_action(snacks, "keymaps", "input"),
				marks = picker_action(snacks, "marks", "list"),
				notifications = picker_action(snacks, "notifications", "list"),
				pickers = function()
					snacks.picker({})
				end,
				quickfix = picker_action(snacks, "qflist", "list"),
				undo = picker_action(snacks, "undo", "list"),
			},
			enabled = true,
			focus = "list",
			layout = { cycle = true },
			sources = {
				explorer = {
					enabled = true,
					finder = "explorer",
					layout = { hidden = { "input", "preview" } },
					replace_netrw = true,
					win = {
						input = { keys = { ["<Esc>"] = { "false", mode = { "n", "x" } } } },
						list = { keys = { ["<Esc>"] = { "false", mode = { "n", "x" } } } },
					},
				},
			},
			win = {
				input = {
					keys = {
						["<c-s>"] = { "flash", mode = { "i" } },
						h = "close",
						l = "confirm",
						s = { "flash", mode = { "n" } },
					},
				},
				list = {
					keys = {
						h = "close",
						l = "confirm",
					},
				},
			},
		},
		scope = { enabled = true },
		scroll = {
			animate = { duration = { step = 10, total = 200 } },
			enabled = true,
		},
		styles = {
			input = { keys = { i_esc = { "<esc>" } } },
			notification = { wo = { wrap = true } },
		},
	})
end

return M
