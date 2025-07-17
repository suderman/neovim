{
  pkgs,
  flake,
  ...
}: let
  codecompanion-lualine-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "codecompanion-lualine-nvim";
    src = flake.inputs.codecompanion-lualine-nvim;
    version = "main";
    doCheck = false;
  };
in {
  vim.assistant.codecompanion-nvim = {
    dependencies = [codecompanion-lualine-nvim];
  };
  vim.statusline.lualine.extraActiveSection.x = [
    "codecompanion"
  ];
}
