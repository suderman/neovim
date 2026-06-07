-- plugin/lsp.lua
-- Uses Neovim native vim.lsp.config/vim.lsp.enable

if vim.g.did_load_lsp_plugin then
	return
end
vim.g.did_load_lsp_plugin = true

-- Global diagnostics configuration lives in suderman.diagnostics.

-- Treesitter context keymap
vim.keymap.set("n", "gC", ":TSContext toggle<CR>", { desc = "Toggle treesitter context" })

-- LSP keymaps
vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { desc = "Code Actions" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Error, Warnings, Hints" })
vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "LSP Hover" })

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set(
	"n",
	"<leader>xb",
	"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	{ desc = "Buffer Diagnostics (Trouble)" }
)
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set(
	"n",
	"<leader>cl",
	"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	{ desc = "LSP Definitions (Trouble)" }
)
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

vim.keymap.set("n", "<leader>f", function()
	vim.b.disableFormatSave = not vim.b.disableFormatSave
	print("Autoformat: " .. (vim.b.disableFormatSave and "disabled" or "enabled"))
end, { desc = "Toggle autoformat" })

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink then
	capabilities = blink.get_lsp_capabilities(capabilities)
end

local function config(server, opts)
	opts = opts or {}
	opts.capabilities = vim.tbl_deep_extend("force", capabilities, opts.capabilities or {})
	vim.lsp.config(server, opts)
end

-- Lua
config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
})

-- Nix
config("nil_ls", {
	settings = {
		["nil-ls"] = {
			formatting = { command = { "alejandra" } },
		},
	},
})

-- Python
config("basedpyright")

-- Go
config("gopls", {
	filetypes = { "go", "gomod", "gowork" },
})

-- C/C++
config("clangd")

-- Rust
config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			cargo = { allFeatures = true },
		},
	},
})

-- TypeScript/JavaScript (use ts_ls, not tsserver)
config("ts_ls")

-- HTML
config("html", {
	filetypes = { "html" },
})

-- CSS
config("cssls")

-- Tailwind CSS
config("tailwindcss", {
	filetypes = {
		"html",
		"css",
		"scss",
		"less",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"php",
		"twig",
		"markdown",
		"vue",
		"svelte",
	},
})

-- Bash
config("bashls")

-- JSON
config("jsonls")

-- YAML
config("yamlls", {
	filetypes = { "yaml" },
})

-- PHP
config("phpactor")

-- Markdown
config("marksman", {
	filetypes = { "markdown" },
})

-- Ruby
config("solargraph")

-- SQL
config("sqls")

vim.lsp.enable({
	"lua_ls",
	"nil_ls",
	"basedpyright",
	"gopls",
	"clangd",
	"rust_analyzer",
	"ts_ls",
	"html",
	"cssls",
	"tailwindcss",
	"bashls",
	"jsonls",
	"yamlls",
	"phpactor",
	"marksman",
	"solargraph",
	"sqls",
})
