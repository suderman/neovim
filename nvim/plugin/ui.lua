-- plugin/ui.lua
if vim.g.did_load_ui_plugin then
	return
end
vim.g.did_load_ui_plugin = true

require("transparent").setup({
	extra_groups = {
		"NormalFloat",
	},
})

require("fidget").setup({
	notification = {
		window = {
			winblend = 0,
			border = "none",
		},
	},
})

require("onedark").setup({
	style = "darker",
	transparent = true,
})
require("onedark").load()

local ok_rm, rm = pcall(require, "render-markdown")
if ok_rm then
	rm.setup({
		file_types = { "markdown", "opencode_output" },
	})
end

require("oil").setup({
	default_file_explorer = false,
	delete_to_trash = true,
	columns = { "icon", "permissions", "size", "mtime" },
	skip_confirm_for_simple_edits = true,
	view_options = {
		show_hidden = true,
		natural_order = true,
		is_always_hidden = function(name, _)
			return name == ".." or name == ".git"
		end,
	},
	win_options = {
		wrap = true,
	},
})

if vim.g.neovide then
	vim.g.neovide_scale_factor = 1.0

	local function change_scale_factor(delta)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
	end

	vim.keymap.set("n", "<D-=>", function()
		change_scale_factor(1.25)
	end)

	vim.keymap.set("n", "<D-->", function()
		change_scale_factor(1 / 1.25)
	end)

	vim.keymap.set("n", "<D-s>", ":w<CR>")
	vim.keymap.set("v", "<D-c>", "+y")
	vim.keymap.set("n", "<D-v>", "+P")
	vim.keymap.set("v", "<D-v>", "+P")
	vim.keymap.set("c", "<D-v>", "<C-R>+")
	vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli')

	vim.keymap.set("", "<D-v>", "+p<CR>", { silent = true })
	vim.keymap.set("!", "<D-v>", "<C-R>+", { silent = true })
	vim.keymap.set("t", "<D-v>", "<C-R>+", { silent = true })
	vim.keymap.set("v", "<D-v>", "<C-R>+", { silent = true })
end

if vim.g.did_load_statusline_plugin then
	return
end
vim.g.did_load_statusline_plugin = true

vim.opt.laststatus = 3

local function lsp_names()
	local excluded_buf_ft = {
		toggleterm = true,
		NvimTree = true,
		["neo-tree"] = true,
		snacks_picker_input = true,
	}

	if excluded_buf_ft[vim.bo.filetype] then
		return ""
	end

	local names = {}
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		if client.name ~= "null" then
			table.insert(names, client.name)
		end
	end
	return #names > 0 and table.concat(names, ", ") or "No Active LSP"
end

local function snacks_picker_cwd()
	local ok_snacks = pcall(require, "snacks")
	if not ok_snacks then
		return ""
	end

	local cwd = vim.fn.getcwd()
	local home = vim.env.HOME
	if cwd:find(home, 1, true) == 1 then
		cwd = "~" .. cwd:sub(#home + 1)
	end
	return cwd
end

local ok_lualine, lualine = pcall(require, "lualine")
if ok_lualine then
	local lualine_x = {
		{
			function()
				local names = lsp_names()
				return names ~= "" and (" " .. names) or ""
			end,
			separator = { left = "" },
		},
		{
			"diagnostics",
			sources = { "nvim_diagnostic", "nvim_lsp" },
			symbols = { error = "󰅙  ", warn = "  ", info = "  ", hint = "󰌵 " },
			colored = true,
			update_in_insert = false,
			always_visible = false,
			diagnostics_color = {
				color_error = { fg = "red" },
				color_warn = { fg = "yellow" },
				color_info = { fg = "cyan" },
			},
		},
	}

	lualine.setup({
		options = {
			theme = "auto",
			globalstatus = true,
			icons_enabled = true,
			refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			always_divide_middle = true,
		},
		sections = {
			lualine_a = {
				{
					"mode",
					icons_enabled = true,
					separator = { left = "▎", right = "" },
				},
				{
					"",
					draw_empty = true,
					separator = { left = "", right = "" },
				},
			},
			lualine_b = {
				{
					"filetype",
					colored = true,
					icon_only = true,
					icon = { align = "left" },
				},
				{
					"filename",
					symbols = { modified = " ", readonly = " " },
					separator = { right = "" },
				},
				{
					"",
					draw_empty = true,
					separator = { left = "", right = "" },
				},
			},
			lualine_c = {
				{
					"diff",
					colored = false,
					diff_color = {
						added = "DiffAdd",
						modified = "DiffChange",
						removed = "DiffDelete",
					},
					symbols = { added = "+", modified = "~", removed = "-" },
					separator = { right = "" },
				},
			},
			lualine_x = lualine_x,
			lualine_y = {
				{
					"",
					draw_empty = true,
					separator = { left = "", right = "" },
				},
				{
					"searchcount",
					maxcount = 999,
					timeout = 120,
					separator = { left = "" },
				},
				{
					"branch",
					icon = " •",
					separator = { left = "" },
				},
			},
			lualine_z = {
				{
					"",
					draw_empty = true,
					separator = { left = "", right = "" },
				},
				{
					"progress",
					separator = { left = "" },
				},
				{ "location" },
				{
					"fileformat",
					color = { fg = "black" },
					symbols = {
						unix = "",
						dos = "",
						mac = "",
					},
				},
			},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {
			{
				filetypes = { "snacks_picker_list", "snacks_picker_input" },
				sections = {
					lualine_a = {
						function()
							return snacks_picker_cwd()
						end,
					},
				},
			},
		},
	})
end

local ok_ai, mini_ai = pcall(require, "mini.ai")
if ok_ai then
	mini_ai.setup({
		custom_textobjects = nil,
		matter = nil,
		moves = nil,
	})
end

local ok_align, mini_align = pcall(require, "mini.align")
if ok_align then
	mini_align.setup()
end

local ok_bracketed, mini_bracketed = pcall(require, "mini.bracketed")
if ok_bracketed then
	mini_bracketed.setup()
end

local ok_surround, mini_surround = pcall(require, "mini.surround")
if ok_surround then
	mini_surround.setup()
end

local ok_diff, mini_diff = pcall(require, "mini.diff")
if ok_diff then
	mini_diff.setup({
		source = mini_diff.gen_source.none(),
	})
end

local ok_lightbulb, lightbulb = pcall(require, "nvim-lightbulb")
if ok_lightbulb then
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
end

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

local ok_smartcol = pcall(require, "smartcolumn")
if ok_smartcol then
	require("smartcolumn").setup({
		colorcolumn = "100",
		custom_colorcolumn = { default = "100" },
		disabled_filetypes = {
			"netrw",
			"snacks_picker_list",
			"snacks_picker_input",
			"neo-tree",
			"NvimTree",
			"qf",
			"help",
			"dashboard",
			"lazy",
			"mason",
			"DiffviewFiles",
			"DiffviewFileHistory",
		},
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
