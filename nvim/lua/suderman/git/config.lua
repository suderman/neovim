local M = {}

function M.setup()
	require("gitsigns").setup({
		signs = {
			add = { text = "│" },
			change = { text = "│" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signcolumn = true,
		numhl = false,
		linehl = false,
		current_line_blame = false,
		word_diff = false,
		watch_gitdir = {
			follow_workers = false,
			auto_awatch = true,
		},
	})

	require("diffview").setup({})
	require("neogit").setup({
		kind = "tab",
		integrated_reloading = false,
	})
	require("git-conflict").setup()
end

return M
