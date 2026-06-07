-- plugin/git.lua
if vim.g.did_load_git_plugin then
	return
end
vim.g.did_load_git_plugin = true

-- Gitsigns
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

-- Diffview
require("diffview").setup({})

-- Neogit (minimal setup)
require("neogit").setup({
	kind = "tab",
	integrated_reloading = false,
})

-- Git-conflict
require("git-conflict").setup()

-- Keymaps for git plugins
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "Neogit" })
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Diffview open" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<CR>", { desc = "Diffview file history" })

-- Git-conflict keymaps
vim.keymap.set("n", "<leader>c0", "<Plug>(git-conflict-none)", { desc = "Choose None [Git-Conflict]" })
vim.keymap.set("n", "<leader>cb", "<Plug>(git-conflict-both)", { desc = "Choose Both [Git-Conflict]" })
vim.keymap.set("n", "<leader>co", "<Plug>(git-conflict-ours)", { desc = "Choose Ours [Git-Conflict]" })
vim.keymap.set("n", "<leader>ct", "<Plug>(git-conflict-theirs)", { desc = "Choose Theirs [Git-Conflict]" })
vim.keymap.set("n", "[x", "<Plug>(git-conflict-next-conflict)", { desc = "Next Conflict [Git-Conflict]" })
vim.keymap.set("n", "]x", "<Plug>(git-conflict-prev-conflict)", { desc = "Prev Conflict [Git-Conflict]" })

-- Gitsigns keymaps
vim.keymap.set("n", "<leader>hD", function()
	require("gitsigns").diffthis("~")
end, { desc = "Diff project [Gitsigns]" })
vim.keymap.set("n", "<leader>hP", require("gitsigns").preview_hunk, { desc = "Preview hunk [Gitsigns]" })
vim.keymap.set("n", "<leader>hR", require("gitsigns").reset_buffer, { desc = "Reset buffer [Gitsigns]" })
vim.keymap.set("n", "<leader>hS", require("gitsigns").stage_buffer, { desc = "Stage buffer [Gitsigns]" })
vim.keymap.set("n", "<leader>hb", function()
	require("gitsigns").blame_line({ full = true })
end, { desc = "Blame line [Gitsigns]" })
vim.keymap.set("n", "<leader>hd", require("gitsigns").diffthis, { desc = "Diff this [Gitsigns]" })
vim.keymap.set("n", "<leader>hr", require("gitsigns").reset_hunk, { desc = "Reset hunk [Gitsigns]" })
vim.keymap.set("n", "<leader>hs", require("gitsigns").stage_hunk, { desc = "Stage hunk [Gitsigns]" })
vim.keymap.set("n", "<leader>hu", require("gitsigns").undo_stage_hunk, { desc = "Undo stage hunk [Gitsigns]" })
vim.keymap.set("n", "<leader>tb", require("gitsigns").toggle_current_line_blame, { desc = "Toggle blame [Gitsigns]" })
vim.keymap.set("n", "<leader>td", require("gitsigns").toggle_deleted, { desc = "Toggle deleted [Gitsigns]" })

-- Visual Gitsigns keymaps
vim.keymap.set("v", "<leader>hr", function()
	local start = vim.fn.line(".")
	local end_ = vim.fn.line("v")
	require("gitsigns").reset_hunk({ start, end_ })
end, { desc = "Reset hunk [Gitsigns]" })
vim.keymap.set("v", "<leader>hs", function()
	local start = vim.fn.line(".")
	local end_ = vim.fn.line("v")
	require("gitsigns").stage_hunk({ start, end_ })
end, { desc = "Stage hunk [Gitsigns]" })

-- Diff-aware navigation (only when not in diff mode)
vim.keymap.set("n", "[c", function()
	if vim.wo.diff then
		return "[c"
	end
	vim.schedule(require("gitsigns").prev_hunk)
	return "<Ignore>"
end, { expr = true, desc = "Previous hunk [Gitsigns]" })
vim.keymap.set("n", "]c", function()
	if vim.wo.diff then
		return "]c"
	end
	vim.schedule(require("gitsigns").next_hunk)
	return "<Ignore>"
end, { expr = true, desc = "Next hunk [Gitsigns]" })
