-- plugin/quickfix.lua
if vim.g.did_load_quickfix_plugin then
  return
end
vim.g.did_load_quickfix_plugin = true

-- Quicker.nvim
require("quicker").setup({
  keys = {
    {
      ">",
      function()
        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
      end,
      desc = "Expand quickfix context",
    },
    {
      "<",
      function()
        require("quicker").collapse()
      end,
      desc = "Collapse quickfix context",
    },
  },
})

-- Quickfix keymaps
vim.keymap.set("n", "<leader>qq", function()
  require("quicker").toggle()
end, { desc = "Toggle quickfix" })

vim.keymap.set("n", "<leader>ql", function()
  require("quicker").toggle({ loclist = true })
end, { desc = "Toggle loclist" })

vim.keymap.set("n", "<C-c>", require("suderman.util").toggle_quickfix, { desc = "Toggle quickfix list" })
vim.keymap.set("n", "gq", require("suderman.util").add_to_quickfix, { desc = "Append current position to quickfix" })
