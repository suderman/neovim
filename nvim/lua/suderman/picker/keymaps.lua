local M = {}

local smart_picker_keys = {
	[":"] = "commands",
	[";"] = "command_history",
	D = "diagnostics",
	F = "quickfix",
	J = "jumps",
	K = "keymaps",
	b = "buffers",
	d = "diagnostics_buffer",
	e = "explorer",
	f = "files",
	g = "grep",
	m = "marks",
	n = "notifications",
	p = "pickers",
	u = "undo",
}

local function pick(snacks, source, focus, opts)
	opts = opts or {}
	opts.source = source
	opts.focus = focus
	snacks.picker.pick(opts)
end

local function smart_picker(snacks)
	snacks.picker.pick({
		source = "smart",
		focus = "input",
		win = {
			input = { keys = smart_picker_keys },
			list = { keys = smart_picker_keys },
		},
	})
end

local function buffer_picker(snacks)
	pick(snacks, "buffers", "list", {
		auto_close = true,
		jump = { close = false },
		layout = { preset = "dropdown", preview = false },
		win = {
			list = {
				keys = {
					["<Space>"] = "close",
					K = "close",
					dd = "bufdelete",
					h = "close",
					l = "confirm",
				},
			},
		},
	})
end

function M.setup(snacks)
	vim.keymap.set("n", "<space>", function()
		smart_picker(snacks)
	end, { desc = "Smart picker" })

	vim.keymap.set("n", "K", function()
		buffer_picker(snacks)
	end, { desc = "Buffers" })

	for _, lhs in ipairs({ "<leader>e", "H", "\\]", "\\=" }) do
		vim.keymap.set("n", lhs, function()
			snacks.explorer()
		end, { desc = "File explorer" })
	end

	vim.keymap.set("n", "<leader>tp", function()
		pick(snacks, "files", "input")
	end, { desc = "Find files" })

	vim.keymap.set("n", "<C-g>", function()
		pick(snacks, "grep", "input")
	end, { desc = "Live grep" })

	vim.keymap.set("n", "\\\\", "<C-^>", { desc = "Last buffer" })

	vim.keymap.set("n", "<M-p>", function()
		pick(snacks, "recent", "list")
	end, { desc = "Recent files" })

	vim.keymap.set("n", "<leader>tg", function()
		pick(snacks, "git_files", "input")
	end, { desc = "Project files" })

	vim.keymap.set("n", "<leader>tbb", function()
		pick(snacks, "buffers", "list")
	end, { desc = "Buffers" })

	vim.keymap.set("n", "<leader>tc", function()
		pick(snacks, "qflist", "list")
	end, { desc = "Quickfix list" })

	vim.keymap.set("n", "<leader>tq", function()
		pick(snacks, "command_history", "list")
	end, { desc = "Command history" })

	vim.keymap.set("n", "<leader>tl", function()
		pick(snacks, "loclist", "list")
	end, { desc = "Location list" })

	vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Oil file explorer" })
	vim.keymap.set("n", "<leader>y", "<cmd>Yazi<cr>", { desc = "Yazi file picker" })
	vim.keymap.set("n", "<leader>cw", "<cmd>Yazi cwd<cr>", { desc = "Yazi at cwd" })
	vim.keymap.set("n", "<C-y>", "<cmd>Yazi toggle<cr>", { desc = "Resume last Yazi session" })
end

return M
