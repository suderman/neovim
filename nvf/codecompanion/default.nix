{
  config,
  pkgs,
  flake,
  ...
}: let
  inherit (flake.lib) nmap vmap ls lua;
  cfg = config.vim.assistant.codecompanion-nvim;
in {
  imports = ls ./.;

  # Override plugin with latest from Github (via flake input)
  vim.pluginOverrides.codecompanion-nvim = pkgs.vimUtils.buildVimPlugin {
    inherit (cfg) dependencies;
    pname = "codecompanion-nvim";
    src = flake.inputs.codecompanion-nvim;
    version = "main";
    doCheck = false;
  };

  vim.assistant.codecompanion-nvim.enable = true;
  vim.assistant.codecompanion-nvim.setupOpts.strategies = {
    chat.adapter = "openrouter";
    chat.slash_commands = lua (lua {
      "buffer".keymaps.modes.n = ["<c-b>" "gb"];
      "file".keymaps.modes.n = ["<c-f>" "gf"];
    });
    inline.adapter = "openrouter";
    cmd.adapter = "openrouter";
  };

  vim.keymaps = [
    (nmap ",," "<cmd>CodeCompanionActions<cr>" "CodeCompanion Actions")
    (nmap ",." "<cmd>CodeCompanionChat Toggle<cr>" "CodeCompanion Chat")
    (nmap ",c" "<cmd>CodeCompanionChat<cr>" "Toggle CodeCompanion Chat")
    (vmap ",y" "<cmd>CodeCompanionChat Add<cr>" "Yank to chat")
    (vmap ",i" "<cmd>CodeCompanion /buffer " "CodeCompanion Inline")
  ];
}
