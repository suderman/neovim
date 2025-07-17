{
  lib,
  pkgs,
  perSystem,
  flake,
  ...
}: let
  inherit (flake.lib) nmap vmap lua;
  #
  # luaAdapters = adapters: opts: let
  #   adaptersList =
  #     lib.mapAttrsToList (
  #       name: value: let
  #         inherit (value) extend;
  #         adapter = lua ((builtins.removeAttrs value ["extend"]) // {inherit name;});
  #       in
  #         # lua
  #         ''
  #           ${name} = function()
  #             return require("codecompanion.adapters").extend("${extend}", ${adapter})
  #           end,
  #         ''
  #     )
  #     adapters;
  # in
  #   lua
  #   # lua
  #   ''
  #     {
  #       opts = ${lua opts},
  #       ${builtins.concatStringsSep "\n" adaptersList}
  #     }
  #   '';
in {
  # vim.assistant.codecompanion-nvim = {
  #   enable = true;
  #   setupOpts = {
  #     display.chat = {
  #       auto_scroll = true;
  #       intro_message = "Welcome to CodeCompanion ✨! Press ? for options";
  #       show_header_separator = false; # Show header separators in the chat buffer?
  #       separator = "─"; # The separator between the different messages in the chat buffer
  #       show_references = true; # Show references (from slash commands and variables) in the chat buffer?
  #       show_settings = false; # Show LLM settings at the top of the chat buffer?
  #       show_token_count = true; # Show the token count for each response?
  #       start_in_insert_mode = false; # Open the chat buffer in insert mode?
  #     };
  #     display.action_palette = {
  #       width = 95;
  #       height = 10;
  #       prompt = "Prompt "; # Prompt used for interactive LLM calls
  #       provider = "default"; # snacks
  #       opts = {
  #         show_default_actions = true; # Show the default actions in the action palette?
  #         show_default_prompt_library = true; # Show the default prompt library in the action palette?
  #       };
  #     };
  #     strategies = {
  #       chat.adapter = "ollama_qwen3";
  #       chat.slash_commands = lua "{ opts = { provider = 'snacks' }, }";
  #       inline.adapter = "ollama_qwen3";
  #       cmd.adapter = "ollama_qwen3";
  #     };
  #
  #     adapters =
  #       luaAdapters {
  #         ollama_qwen3 = {
  #           extend = "ollama";
  #           env.url = "http://10.1.0.6:11434";
  #           headers."Content-Type" = "application/json";
  #           parameters.sync = true;
  #           schema = {
  #             model.default = "qwen3:30b-a3b";
  #             temperature.default = 0.6;
  #             top_p.default = 0.95;
  #             top_k.default = 20;
  #             min_p.default = 0;
  #           };
  #         };
  #         ollama_qwen3_supa_fast = {
  #           extend = "ollama";
  #           env.url = "http://10.1.0.6:11434";
  #           headers."Content-Type" = "application/json";
  #           parameters.sync = true;
  #           schema = {
  #             model.default = "qwen3:30b-a3b";
  #             temperature.default = 0.6;
  #             top_p.default = 0.95;
  #             top_k.default = 20;
  #             min_p.default = 0;
  #           };
  #         };
  #         openrouter_claude = {
  #           extend = "openai_compatible";
  #           env.url = "https://openrouter.ai/api";
  #           env.api_key = "OPENROUTER_API_KEY";
  #           schema.model.default = "anthropic/claude-3.7-sonnet";
  #         };
  #       } {
  #         show_defaults = false;
  #       };
  #
  #     extensions = {
  #       spinner = {};
  #       mcphub = {
  #         callback = "mcphub.extensions.codecompanion";
  #         opts = {
  #           show_result_in_chat = true; #  Show mcp tool results in chat
  #           make_vars = true; #  Convert resources to #variables
  #           make_slash_commands = true; #  Add prompts as /slash commands
  #         };
  #       };
  #     };
  #   };
  # };
  #
  # # Override plugin with latest from Github (via flake input)
  # # and include dependency of mcphub-nvim
  # vim.pluginOverrides.codecompanion-nvim = let
  #   codecompanion-spinner-nvim = pkgs.vimUtils.buildVimPlugin {
  #     pname = "codecompanion-spinner-nvim";
  #     src = flake.inputs.codecompanion-spinner-nvim;
  #     version = "main";
  #     doCheck = false;
  #   };
  #   codecompanion-lualine-nvim = pkgs.vimUtils.buildVimPlugin {
  #     pname = "codecompanion-lualine-nvim";
  #     src = flake.inputs.codecompanion-lualine-nvim;
  #     version = "main";
  #     doCheck = false;
  #   };
  # in
  #   pkgs.vimUtils.buildVimPlugin {
  #     pname = "codecompanion-nvim";
  #     src = flake.inputs.codecompanion-nvim;
  #     version = "main";
  #     doCheck = false;
  #     dependencies = [
  #       perSystem.mcphub-nvim.default
  #       codecompanion-spinner-nvim
  #       codecompanion-lualine-nvim
  #     ];
  #   };
  #
  # # https://ravitemer.github.io/mcphub.nvim/extensions/avante.html
  # vim.luaConfigRC."mcphub.nvim" =
  #   lib.nvim.dag.entryBefore ["lazyConfigs"]
  #   # lua
  #   ''
  #     require('mcphub').setup {
  #       cmd = "${perSystem.mcp-hub.default}/bin/mcp-hub",
  #       auto_approve = true,
  #       extensions = {
  #         avante = {
  #           make_slash_commands = true, -- make /slash commands from MCP server prompts
  #         }
  #       }
  #     }
  #   '';
  #
  # # https://ravitemer.github.io/mcphub.nvim/other/troubleshooting.html#environment-requirements
  # vim.extraPackages = with pkgs; [
  #   nodejs # npx
  #   python3
  #   uv # uvx
  # ];
  #
  # vim.languages.markdown.extensions.render-markdown-nvim.setupOpts.file_types = [
  #   "codecompanion"
  #   # "Avante"
  # ];
  #
  # vim.autocomplete.blink-cmp.setupOpts.sources.per_filetype = {
  #   codecompanion = ["codecompanion"];
  # };
  #
  # # Add mcphub to lualine
  # vim.statusline.lualine.extraActiveSection.x = [
  #   # "require('mcphub.extensions.lualine')"
  #   "codecompanion"
  #   # ''icon = " "''
  #   # ''spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }''
  #   # ''done_symbol = "✓"''
  # ];
  #
  # vim.keymaps = [
  #   (nmap "<leader>ac" "<cmd>CodeCompanionChat<cr>" "CodeCompanion Chat")
  #   (nmap "<leader>at" "<cmd>CodeCompanionChat Toggle<cr>" "CodeCompanion Chat")
  #   (nmap "\\" "<cmd>CodeCompanionChat Toggle<cr>" "CodeCompanion Chat")
  #   (nmap "<C-a>" "<cmd>CodeCompanionChat Toggle<cr>" "Toggle CodeCompanion Chat")
  #   (nmap "<leader>aa" "<cmd>CodeCompanionActions<cr>" "CodeCompanion Actions")
  #   (vmap "<leader>ay" "<cmd>CodeCompanionChat Add<cr>" "Yank to chat")
  # ];
}
