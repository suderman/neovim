local M = {}

local function select_textobject(query, group)
	return function()
		require("nvim-treesitter-textobjects.select").select_textobject(query, group)
	end
end

local function swap_next(query)
	return function()
		require("nvim-treesitter-textobjects.swap").swap_next(query)
	end
end

local function swap_previous(query)
	return function()
		require("nvim-treesitter-textobjects.swap").swap_previous(query)
	end
end

local function move(method, query, group)
	return function()
		require("nvim-treesitter-textobjects.move")[method](query, group)
	end
end

function M.setup()
	vim.keymap.set({ "x", "o" }, "af", select_textobject("@function.outer", "textobjects"))
	vim.keymap.set({ "x", "o" }, "if", select_textobject("@function.inner", "textobjects"))
	vim.keymap.set({ "x", "o" }, "ac", select_textobject("@class.outer", "textobjects"))
	vim.keymap.set({ "x", "o" }, "ic", select_textobject("@class.inner", "textobjects"))
	vim.keymap.set({ "x", "o" }, "as", select_textobject("@local.scope", "locals"))

	vim.keymap.set("n", "<leader>a", swap_next("@parameter.inner"))
	vim.keymap.set("n", "<leader>A", swap_previous("@parameter.outer"))

	vim.keymap.set(
		{ "n", "x", "o" },
		"]m",
		move("goto_next_start", "@function.outer", "textobjects"),
		{ desc = "Next function (start)" }
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"]M",
		move("goto_next_end", "@function.outer", "textobjects"),
		{ desc = "Next function (end)" }
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"]p",
		move("goto_next_start", "@parameter.outer", "textobjects"),
		{ desc = "Next parameter (start)" }
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"]P",
		move("goto_next_end", "@parameter.outer", "textobjects"),
		{ desc = "Next parameter (end)" }
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"[m",
		move("goto_previous_start", "@function.outer", "textobjects"),
		{ desc = "Previous function (start)" }
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"[M",
		move("goto_previous_end", "@function.outer", "textobjects"),
		{ desc = "Previous function (end)" }
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"[p",
		move("goto_previous_start", "@parameter.outer", "textobjects"),
		{ desc = "Previous parameter (start)" }
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"[P",
		move("goto_previous_end", "@parameter.outer", "textobjects"),
		{ desc = "Previous parameter (end)" }
	)
end

return M
