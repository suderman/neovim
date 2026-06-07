vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("suderman-colorcolumn", { clear = true }),
	callback = function(args)
		local disabled_filetypes = {
			netrw = true,
			snacks_picker_list = true,
			snacks_picker_input = true,
			["neo-tree"] = true,
			NvimTree = true,
			qf = true,
			help = true,
			dashboard = true,
			lazy = true,
			mason = true,
			DiffviewFiles = true,
			DiffviewFileHistory = true,
		}

		if disabled_filetypes[vim.bo[args.buf].filetype] then
			vim.wo.colorcolumn = ""
		else
			vim.wo.colorcolumn = "100"
		end
	end,
})
