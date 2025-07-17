{
  pkgs,
  flake,
  ...
}: let
  codecompanion-spinner-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "codecompanion-spinner-nvim";
    src = flake.inputs.codecompanion-spinner-nvim;
    version = "main";
    doCheck = false;
  };
in {
  vim.assistant.codecompanion-nvim = {
    # setupOpts.extensions.spinner = {};
    # dependencies = [codecompanion-spinner-nvim];
  };
}
