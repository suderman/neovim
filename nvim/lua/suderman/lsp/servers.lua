local M = {}

local enabled_servers = {
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
}

local server_configs = {
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
			},
		},
	},
	nil_ls = {
		settings = {
			["nil-ls"] = {
				formatting = { command = { "alejandra" } },
			},
		},
	},
	gopls = {
		filetypes = { "go", "gomod", "gowork" },
	},
	rust_analyzer = {
		settings = {
			["rust-analyzer"] = {
				cargo = { allFeatures = true },
			},
		},
	},
	html = {
		filetypes = { "html" },
	},
	tailwindcss = {
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
	},
	yamlls = {
		filetypes = { "yaml" },
	},
	marksman = {
		filetypes = { "markdown" },
	},
}

local function config(server, capabilities)
	local opts = server_configs[server] or {}
	opts = vim.deepcopy(opts)
	opts.capabilities = vim.tbl_deep_extend("force", capabilities, opts.capabilities or {})
	vim.lsp.config(server, opts)
end

function M.setup(capabilities)
	for _, server in ipairs(enabled_servers) do
		config(server, capabilities)
	end

	vim.lsp.enable(enabled_servers)
end

return M
