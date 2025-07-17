{
  lib,
  pkgs,
  perSystem,
  ...
}: {
  vim.assistant.codecompanion-nvim = {
    dependencies = [perSystem.mcphub-nvim.default];
    setupOpts.extensions.mcphub = {
      callback = "mcphub.extensions.codecompanion";
      opts = {
        show_result_in_chat = true; #  Show mcp tool results in chat
        make_vars = true; #  Convert resources to #variables
        make_slash_commands = true; #  Add prompts as /slash commands
      };
    };
  };

  # https://ravitemer.github.io/mcphub.nvim/extensions/avante.html
  vim.luaConfigRC."mcphub.nvim" =
    lib.nvim.dag.entryBefore ["lazyConfigs"]
    # lua
    ''
      require('mcphub').setup {
        cmd = "${perSystem.mcp-hub.default}/bin/mcp-hub",
        auto_approve = true,
        auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically
      }
    '';

  # https://ravitemer.github.io/mcphub.nvim/other/troubleshooting.html#environment-requirements
  vim.extraPackages = with pkgs; [
    nodejs # npx
    python3
    uv # uvx
  ];

  # Add mcphub to lualine
  vim.statusline.lualine.extraActiveSection.x = [
    "require('mcphub.extensions.lualine')"
  ];
}
