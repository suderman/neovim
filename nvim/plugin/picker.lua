-- plugin/picker.lua
-- Snacks owns picker, explorer, and related navigation UI.

if vim.g.did_load_picker_plugin then
	return
end
vim.g.did_load_picker_plugin = true

local ok_snacks, snacks = pcall(require, "snacks")
if not ok_snacks then
	return
end

require("suderman.picker.config").setup(snacks)
require("suderman.picker.keymaps").setup(snacks)
