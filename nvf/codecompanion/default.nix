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
    chat.tools.opts = {
      auto_submit_errors = true; # Send any errors to the LLM automatically?
      auto_submit_success = true; # Send any successful output to the LLM automatically?
      default_tools = [
        "files" # read_file create_file insert_edit_into_file file_search grep_search get_changed_files
        "cmd_runner" # run shell commands
        "web_search" # search web with tavily
      ];
    };
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
