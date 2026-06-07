-- plugin/git.lua
if vim.g.did_load_git_plugin then
	return
end
vim.g.did_load_git_plugin = true

require("suderman.git.config").setup()
require("suderman.git.keymaps").setup()
