{flake, ...}: let
  inherit (flake.lib) lua;
in {
  vim.undoFile.enable = true;
  vim.undoFile.path = lua "vim.fn.stdpath('state') .. '/undo'";
}
