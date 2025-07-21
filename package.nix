{
  pkgs,
  perSystem,
  flake,
  ...
}:
(flake.inputs.nvf.lib.neovimConfiguration {
  inherit pkgs;
  extraSpecialArgs = {inherit flake perSystem;};
  modules = flake.lib.ls ./nvf;
}).neovim
