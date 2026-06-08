local M = {}

local function path_exists(path)
	return vim.uv.fs_stat(path) ~= nil
end

local function start_dir(buf)
	local filename = vim.api.nvim_buf_get_name(buf)
	if filename ~= "" then
		return vim.fs.dirname(filename)
	end

	return vim.fn.getcwd()
end

local function find_upward(buf, files)
	local dir = start_dir(buf)

	while dir do
		for _, file in ipairs(files) do
			local path = vim.fs.joinpath(dir, file)
			if path_exists(path) then
				return path
			end
		end

		local parent = vim.fs.dirname(dir)
		if parent == dir then
			return nil
		end
		dir = parent
	end

	return nil
end

local function composer_mentions_phpstan(buf)
	local composer = find_upward(buf, { "composer.json" })
	if not composer then
		return false
	end

	local ok, lines = pcall(vim.fn.readfile, composer)
	if not ok then
		return false
	end

	local decode_ok, json = pcall(vim.json.decode, table.concat(lines, "\n"))
	if not decode_ok or type(json) ~= "table" then
		return false
	end

	local function has_phpstan(value)
		if type(value) == "string" then
			return value:find("phpstan", 1, true) ~= nil
		end

		if type(value) == "table" then
			for _, item in pairs(value) do
				if has_phpstan(item) then
					return true
				end
			end
		end

		return false
	end

	return has_phpstan(json.scripts) or has_phpstan(json.config) or has_phpstan(json.extra)
end

local function configure_eslint(lint)
	-- Do not replace built-in linter definitions with partial tables, or we lose
	-- parser/args/stdin settings and nvim-lint crashes when the linter runs.
	local eslint_d = lint.linters.eslint_d
	if not eslint_d then
		return
	end

	eslint_d.required_files = {
		"eslint.config.js",
		"eslint.config.mjs",
		".eslintrc",
		".eslintrc.cjs",
		".eslintrc.json",
		".eslintrc.js",
		".eslintrc.yml",
	}
end

local function configure_php(lint)
	local phpcs = lint.linters.phpcs
	if phpcs then
		phpcs.required_files = {
			"phpcs.xml",
			"phpcs.xml.dist",
			"phpcs.ruleset.xml",
			".phpcs.xml",
			".phpcs.xml.dist",
			"ruleset.xml",
		}
	end

	local phpstan = lint.linters.phpstan
	if phpstan then
		phpstan.required_files = {
			"phpstan.neon",
			"phpstan.neon.dist",
			"phpstan.dist.neon",
		}
		phpstan.should_run = function(buf)
			return find_upward(buf, phpstan.required_files) ~= nil or composer_mentions_phpstan(buf)
		end
	end
end

local function should_run_linter(lint, name, buf)
	local linter = lint.linters[name]
	if not linter then
		return false
	end

	if type(linter) == "function" then
		linter = linter()
	end

	if linter.should_run then
		return linter.should_run(buf)
	end

	local required_files = linter.required_files
	if required_files == nil or vim.tbl_isempty(required_files) then
		return true
	end

	local cwd = linter.cwd
	if type(cwd) == "function" then
		cwd = cwd(buf)
	end
	cwd = cwd or start_dir(buf)
	for _, file in ipairs(required_files) do
		local path = vim.fs.joinpath(cwd, file)
		if path_exists(path) then
			return true
		end
	end

	return find_upward(buf, required_files) ~= nil
end

local function lint_buffer(lint, buf)
	local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
	local names = lint._resolve_linter_by_ft(ft)
	if vim.tbl_isempty(names) then
		return
	end

	local eligible = vim.tbl_filter(function(name)
		return should_run_linter(lint, name, buf)
	end, names)
	if vim.tbl_isempty(eligible) then
		return
	end

	lint.try_lint(eligible)
end

function M.setup(lint)
	lint.linters_by_ft = {
		html = { "htmlhint" },
		lua = { "luacheck" },
		markdown = { "markdownlint-cli2" },
		nix = { "statix", "deadnix" },
		php = { "phpstan", "phpcs" },
		ruby = { "rubocop" },
		sh = { "shellcheck" },
		sql = { "sqlfluff" },
		twig = { "djlint" },
		typescript = { "eslint_d" },
		typescriptreact = { "eslint_d" },
	}

	configure_eslint(lint)
	configure_php(lint)

	vim.api.nvim_create_autocmd("BufWritePost", {
		callback = function(args)
			lint_buffer(lint, args.buf)
		end,
	})
end

return M
