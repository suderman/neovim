-- plugin/ui.lua
if vim.g.did_load_ui_plugin then
  return
end
vim.g.did_load_ui_plugin = true

require("suderman.ui.colors")
require("suderman.ui.notifications")
require("suderman.ui.markdown")
require("suderman.ui.which-key")
require("suderman.ui.explorer")
require("suderman.ui.colorcolumn")
require("suderman.ui.neovide")
require("suderman.ui.statusline")
require("suderman.ui.editing")
require("suderman.ui.lsp")
require("suderman.ui.extras")
