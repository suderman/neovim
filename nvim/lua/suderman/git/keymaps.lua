local M = {}

local function visual_range()
	return { vim.fn.line("."), vim.fn.line("v") }
end

function M.setup()
	local gitsigns = require("gitsigns")

	vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "Open Neogit" })
	vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Open Diffview" })
	vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<CR>", { desc = "Diffview file history" })

	vim.keymap.set("n", "<leader>c0", "<Plug>(git-conflict-none)", { desc = "Use neither conflict side" })
	vim.keymap.set("n", "<leader>cb", "<Plug>(git-conflict-both)", { desc = "Use both conflict sides" })
	vim.keymap.set("n", "<leader>co", "<Plug>(git-conflict-ours)", { desc = "Use our conflict side" })
	vim.keymap.set("n", "<leader>ct", "<Plug>(git-conflict-theirs)", { desc = "Use their conflict side" })
	vim.keymap.set("n", "<leader>cn", "<Plug>(git-conflict-next-conflict)", { desc = "Next git conflict" })
	vim.keymap.set("n", "<leader>cp", "<Plug>(git-conflict-prev-conflict)", { desc = "Previous git conflict" })

	vim.keymap.set("n", "<leader>hD", function()
		gitsigns.diffthis("~")
	end, { desc = "Diff against index" })
	vim.keymap.set("n", "<leader>hP", gitsigns.preview_hunk, { desc = "Preview hunk" })
	vim.keymap.set("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
	vim.keymap.set("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
	vim.keymap.set("n", "<leader>hb", function()
		gitsigns.blame_line({ full = true })
	end, { desc = "Blame line" })
	vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff hunk" })
	vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
	vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
	vim.keymap.set("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
	vim.keymap.set("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle blame" })
	vim.keymap.set("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle deleted" })

	vim.keymap.set("v", "<leader>hr", function()
		gitsigns.reset_hunk(visual_range())
	end, { desc = "Reset hunk" })
	vim.keymap.set("v", "<leader>hs", function()
		gitsigns.stage_hunk(visual_range())
	end, { desc = "Stage hunk" })

	-- Hunk navigation is provided by mini.diff on [h, ]h, [H, and ]H.
end

return M
