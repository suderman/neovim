{flake, ...}: let
  inherit (flake.lib) lua;
in {
  vim.assistant.copilot = {
    enable = true;
    cmp.enable = true;
  };
}
