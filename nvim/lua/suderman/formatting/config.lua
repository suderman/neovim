local M = {}

local disabled_filetypes = {
	[""] = true,
	netrw = true,
	qf = true,
	snacks_picker_input = true,
}

local function format_on_save(bufnr)
	if vim.b[bufnr].disableFormatSave then
		return nil
	end

	if disabled_filetypes[vim.bo[bufnr].filetype] then
		return nil
	end

	return { timeout_ms = 5000, lsp_format = "fallback" }
end

function M.setup(conform)
	conform.setup({
		formatters_by_ft = {
			nix = { "alejandra" },
			lua = { "stylua" },
			python = { "ruff_format", "ruff" },
			php = { "php_cs_fixer" },
			twig = { "djlint" },
			c = { "clang_format" },
			cpp = { "clang_format" },
			rust = { "rustfmt" },
			go = { "gofmt", "goimports" },
			javascript = { "prettierd", "prettier" },
			typescript = { "prettierd", "prettier" },
			javascriptreact = { "prettierd", "prettier" },
			typescriptreact = { "prettierd", "prettier" },
			html = { "prettierd", "prettier" },
			css = { "prettierd", "prettier" },
			json = { "prettierd", "prettier" },
			yaml = { "prettierd", "prettier" },
			markdown = { "prettierd", "prettier" },
			sql = { "sqlfluff" },
			bash = { "shfmt" },
			sh = { "shfmt" },
		},
		format_on_save = format_on_save,
		notify_no_formatters = false,
	})
end

return M
