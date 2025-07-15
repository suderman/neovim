{
  pkgs,
  flake,
  ...
}: let
  inherit (flake.lib) nmap lua luaCall;
in {
  # # Better Quickfix
  # vim.lazy.plugins.nvim-bqf = {
  #   package = pkgs.vimPlugins.nvim-bqf;
  # };
  # vim.luaConfigRC.nvim-bqf =
  #   # lua
  #   ''
  #     require('bqf').setup{}
  #   '';

  vim.lazy.plugins."quicker.nvim" = {
    package = pkgs.vimPlugins.quicker-nvim;
  };
  vim.keymaps = [
    (nmap "<leader>qq" (luaCall "require('quicker').toggle" {}) "Toggle quickfix")
    (nmap "<leader>ql" (luaCall "require('quicker').toggle" {loclist = true;}) "Toggle loclist")
  ];
  vim.luaConfigRC.quicker =
    # lua
    ''
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
    '';

  vim.luaConfigRC.quickfix-add =
    # lua
    ''
      vim.keymap.set('n', '<leader>qa', function()
        local pos = vim.api.nvim_win_get_cursor(0)
        local file = vim.api.nvim_buf_get_name(0)

        if file == "" then
          print("No file name available.")
          return
        end

        vim.fn.setqflist({
          {
            filename = file,
            lnum = pos[1],
            col = pos[2] + 1,
            text = vim.fn.getline('.')
          }
        }, 'a')  -- 'a' = append

        print(string.format("Added to quickfix: %s:%d", file, pos[1]))
      end, { desc = "Append current position to quickfix" })

    '';
}
