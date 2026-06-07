local ok_icons = pcall(require, "nvim-web-devicons")
if ok_icons then
	require("nvim-web-devicons").setup({
		color_icons = true,
		override = {},
	})
end

local ok_hlundo = pcall(require, "highlight-undo")
if ok_hlundo then
	require("highlight-undo").setup({
		undo = { hlgroup = "HighlightUndo", duration = 300 },
		redo = { hlgroup = "HighlightUndo", duration = 300 },
	})
end

local ok_scrollbar = pcall(require, "scrollbar")
if ok_scrollbar then
	require("scrollbar").setup({
		excluded_filetypes = {
			"prompt",
			"snacks_picker_list",
			"snacks_picker_input",
			"neo-tree",
			"NvimTree",
			"Notify",
			"alpha",
			"dashboard",
			"fern",
			"fzf",
			"hg",
			"mason",
			"neogit",
			"nerdtree",
			"null-ls",
			"snacks",
			"snacks_picker",
			"qf",
			"help",
			"lspinfo",
			"man",
		},
		excluded_buftypes = { "terminal" },
	})
end

local ok_docsview = pcall(require, "docs-view")
if ok_docsview then
	require("docs-view").setup({
		height = 10,
		position = "right",
		update_mode = "auto",
		width = 60,
	})
	vim.keymap.set("n", "<leader>lvt", "<cmd>DocsViewToggle<CR>", { desc = "DocsView: Toggle panel" })
	vim.keymap.set("n", "<leader>lvu", "<cmd>DocsViewUpdate<CR>", { desc = "DocsView: Update panel" })
end
