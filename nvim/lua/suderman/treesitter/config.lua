local M = {}

function M.setup()
  require("treesitter-context").setup({
    max_lines = 3,
  })

  require("ts_context_commentstring").setup()

  -- nvim-treesitter 0.10+ only manages parsers/queries. Highlight, folds, and
  -- indentation are Neovim/native buffer options now.
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("suderman-treesitter", { clear = true }),
    callback = function(args)
      local ok = pcall(vim.treesitter.start, args.buf)
      if not ok then
        return
      end

      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo.foldmethod = "expr"
    end,
  })
end

return M
