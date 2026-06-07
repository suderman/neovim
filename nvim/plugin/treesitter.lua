-- plugin/treesitter.lua
if vim.g.did_load_treesitter_plugin then
	return
end
vim.g.did_load_treesitter_plugin = true

vim.filetype.add({
	extension = {
		twig = "twig",
	},
})

vim.treesitter.language.register("twig", "twig")

require("suderman.treesitter.keymaps").setup()
require("suderman.treesitter.config").setup()
