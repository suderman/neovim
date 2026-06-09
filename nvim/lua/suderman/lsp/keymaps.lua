local M = {}

function M.setup()
  vim.keymap.set("n", "gC", ":TSContext toggle<CR>", { desc = "Toggle treesitter context" })

  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
  vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Error, Warnings, Hints" })
  vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { desc = "LSP Hover" })

  vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
  vim.keymap.set(
    "n",
    "<leader>xb",
    "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    { desc = "Buffer Diagnostics (Trouble)" }
  )
  vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
  vim.keymap.set(
    "n",
    "<leader>cl",
    "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    { desc = "LSP Definitions (Trouble)" }
  )
  vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
  vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

  vim.keymap.set("n", "<leader>f", function()
    vim.b.disableFormatSave = not vim.b.disableFormatSave
    print("Autoformat: " .. (vim.b.disableFormatSave and "disabled" or "enabled"))
  end, { desc = "Toggle autoformat" })
end

return M
