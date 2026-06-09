-- plugin/lsp.lua
-- Uses Neovim native vim.lsp.config/vim.lsp.enable.

if vim.g.did_load_lsp_plugin then
  return
end
vim.g.did_load_lsp_plugin = true

require("suderman.lsp.keymaps").setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

require("suderman.lsp.servers").setup(capabilities)
