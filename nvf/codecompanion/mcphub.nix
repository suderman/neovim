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
    # lua
    ''
      require('lualine').setup {
        sections = {
          lualine_x = {
            {
              function()
                -- Check if MCPHub is loaded
                if not vim.g.loaded_mcphub then
                  return "󰐻 -"
                end

                local count = vim.g.mcphub_servers_count or 0
                local status = vim.g.mcphub_status or "stopped"
                local executing = vim.g.mcphub_executing

                -- Show "-" when stopped
                if status == "stopped" then
                  return "󰐻 -"
                end

                -- Show spinner when executing, starting, or restarting
                if executing or status == "starting" or status == "restarting" then
                  local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
                  local frame = math.floor(vim.loop.now() / 100) % #frames + 1
                  return "󰐻 " .. frames[frame]
                end

                return "󰐻 " .. count
              end,
              color = function()
                if not vim.g.loaded_mcphub then
                  return { fg = "#6c7086" } -- Gray for not loaded
                end

                local status = vim.g.mcphub_status or "stopped"
                if status == "ready" or status == "restarted" then
                  return { fg = "#50fa7b" } -- Green for connected
                elseif status == "starting" or status == "restarting" then
                  return { fg = "#ffb86c" } -- Orange for connecting
                else
                  return { fg = "#ff5555" } -- Red for error/stopped
                end
              end,
            },
          },
        },
      }
    ''
  ];
}
