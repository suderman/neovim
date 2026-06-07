-- plugin/formatting.lua
-- Formatting configuration using conform.nvim
if vim.g.did_load_formatting_plugin then
	return
end
vim.g.did_load_formatting_plugin = true

local ok_conform, conform = pcall(require, "conform")
if not ok_conform then
	return
end

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
	format_on_save = function(bufnr)
		if vim.b[bufnr].disableFormatSave then
			return nil
		end

		local filetype = vim.bo[bufnr].filetype
		if filetype == "" or filetype == "qf" or filetype == "netrw" or filetype == "snacks_picker_input" then
			return nil
		end

		return { timeout_ms = 5000, lsp_format = "fallback" }
	end,
	notify_no_formatters = false,
})
