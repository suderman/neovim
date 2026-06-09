-- plugin/completion.lua
-- Uses blink.cmp

if vim.g.did_load_completion_plugin then
  return
end
vim.g.did_load_completion_plugin = true

local blink = require("blink.cmp")

require("suderman.completion.config").setup(blink)
