{flake, ...}: let
  # Module args with lib included
  inherit (flake) inputs;
  inherit (inputs.nixpkgs) lib;
  args = {inherit flake inputs lib;};
in rec {
  inherit (lib.generators) mkLuaInline;
  inherit (inputs.nvf.lib.nvim.lua) toLuaObject;

  # List directories and files that can be imported by nix
  ls = import ./ls.nix args;

  # Build keymap attr and detect if action is lua
  keyMap = import ./keyMap.nix args;

  # Shortcuts to each mode
  imap = key: action: desc: keyMap "i" key action desc;
  nmap = key: action: desc: keyMap "n" key action desc;
  tmap = key: action: desc: keyMap "t" key action desc;
  vmap = key: action: desc: keyMap "v" key action desc;

  # function name and options argument
  mkLuaCallback = name: options:
  # lua
  ''
    function()
      ${name}(${toLuaObject options})
    end
  '';
}
