local M = {}

local root_markers = {
	"tailwind.config.js",
	"tailwind.config.cjs",
	"tailwind.config.mjs",
	"tailwind.config.ts",
	"postcss.config.js",
	"postcss.config.cjs",
	"postcss.config.mjs",
	"postcss.config.ts",
}

local function package_uses_tailwind(package_json)
	local ok, lines = pcall(vim.fn.readfile, package_json)
	if not ok then
		return false
	end

	local decoded_ok, package = pcall(vim.json.decode, table.concat(lines, "\n"))
	if not decoded_ok or type(package) ~= "table" then
		return false
	end

	for _, field in ipairs({ "dependencies", "devDependencies", "peerDependencies", "optionalDependencies" }) do
		local dependencies = package[field]
		if type(dependencies) == "table" and dependencies.tailwindcss then
			return true
		end
	end

	return false
end

function M.root_dir(bufnr, on_dir)
	local filename = vim.api.nvim_buf_get_name(bufnr)
	local marker = vim.fs.find(root_markers, { path = filename, upward = true })[1]
	if marker then
		on_dir(vim.fs.dirname(marker))
		return
	end

	for _, package_json in ipairs(vim.fs.find("package.json", { path = filename, upward = true })) do
		if package_uses_tailwind(package_json) then
			on_dir(vim.fs.dirname(package_json))
			return
		end
	end
end

return M
