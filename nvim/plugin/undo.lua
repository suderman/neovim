-- plugin/undo.lua
if vim.g.did_load_undo_plugin then
	return
end
vim.g.did_load_undo_plugin = true

-- Undo file location is set in suderman.opts via opt.undofile.
