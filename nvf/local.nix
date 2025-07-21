{lib, ...}: {
  vim.luaConfigRC."local" =
    lib.nvim.dag.entryAfter ["mappings"]
    # lua
    ''
      -- Expands to full path
      local dir = vim.fn.expand("~/.config/nvf/lua/local")
      local file = dir .. "/init.lua"

      -- Create directory & file if it doesn't exist
      if vim.fn.filereadable(file) == 0 then
        vim.fn.system({ "mkdir", "-p", dir })
        vim.fn.system({ "touch", file })

      -- Otherwise, require the package
      else
        require("local")
      end
    '';
}
