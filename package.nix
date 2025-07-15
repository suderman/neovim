{
  pkgs,
  perSystem,
  flake,
  ...
}: let
  inherit (flake.inputs.nvf.lib) neovimConfiguration;
  inherit (flake.inputs.nixpkgs.lib) recursiveUpdate;

  basic = [
    {
      # vim.viAlias = true;
      # vim.vimAlias = true;
      vim.enableLuaLoader = true;
      vim.globals.mapleader = " "; # use space as leader key
      vim.globals.maplocalleader = ","; # use comma as local leader key
      vim.options.mouse = "nvi"; # normal, visual, insert, commandline, help, all, r
    }
  ];

  local = [
    {
      vim.luaConfigRC.local =
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
  ];
  # inherit
  #   (flake.inputs.nvf.lib.neovimConfiguration {
  #     inherit pkgs;
  #     extraSpecialArgs = {
  #       inherit flake perSystem;
  #     };
  #     modules = basic ++ (flake.lib.ls ./nvf) ++ local;
  #   })
  #   neovim
  #   ;
in
  flake.inputs.nixpkgs.lib.recursiveUpdate
  (flake.inputs.nvf.lib.neovimConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit flake perSystem;
    };
    modules = basic ++ (flake.lib.ls ./nvf) ++ local;
  }).neovim
  {
    inherit (pkgs.neovim-unwrapped) lua;
    meta = {
      inherit
        (pkgs.neovim-unwrapped.meta)
        longDescription
        license
        teams
        platforms
        ;
      homepage = "https://github.com/suderman/neovim";
    };
  }
