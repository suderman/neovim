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

require("suderman.formatting.config").setup(conform)
