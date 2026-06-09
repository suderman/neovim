-- plugin/opencode.lua
-- OpenCode integration

if vim.g.did_load_opencode_plugin then
  return
end
vim.g.did_load_opencode_plugin = true

local ok_opencode, opencode = pcall(require, "opencode")
if not ok_opencode then
  return
end

vim.o.autoread = true

require("suderman.opencode.config").setup(opencode)
require("suderman.opencode.keymaps").setup()
