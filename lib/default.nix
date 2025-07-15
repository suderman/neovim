{flake, ...}: let
  # Module args with lib included
  inherit (flake) inputs;
  inherit (inputs.nixpkgs) lib;
  args = {inherit flake inputs lib;};
in
  flake.inputs.nixos.lib
  // rec {
    inherit (lib.generators) mkLuaInline;
    inherit (inputs.nvf.lib.nvim.lua) toLuaObject;

    # Create inline lua or generate table from object
    lua = args:
      if builtins.isString args
      then mkLuaInline args
      else toLuaObject args;

    # function name and options
    luaCall = name: args:
    # lua
    ''
      function()
        ${name}(${toLuaObject args})
      end
    '';

    # Build keymap attr and detect if action is lua
    keyMap = import ./keyMap.nix args;

    # Shortcuts to each mode
    imap = key: action: desc: keyMap "i" key action desc;
    nmap = key: action: desc: keyMap "n" key action desc;
    tmap = key: action: desc: keyMap "t" key action desc;
    vmap = key: action: desc: keyMap "v" key action desc;
  }
