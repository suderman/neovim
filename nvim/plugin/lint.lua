-- plugin/lint.lua
if vim.g.did_load_lint_plugin then
	return
end
vim.g.did_load_lint_plugin = true

local ok_lint, lint = pcall(require, "lint")
if not ok_lint then
	return
end

require("suderman.lint.config").setup(lint)
