-- plugin/undo.lua
-- Undo history configuration migrated from nvf/undo.nix

if vim.g.did_load_undo_plugin then
  return
end
vim.g.did_load_undo_plugin = true

-- Undo file location (already set in init.lua via opt.undofile)
-- Additional path configuration from nvf/undo.nix
-- Note: The path is set via lua in nvf which uses vim.fn.stdpath('state') .. '/undo'
-- Here we just ensure the directory exists (Neovim creates it automatically)
