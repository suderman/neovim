{
  config,
  lib,
  flake,
  ...
}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) attrs enum listOf package;
  cfg = config.vim.assistant.codecompanion-nvim;

  # Convert attr set to lua table of functions
  luaAdapters = adapters: opts: let
    inherit (builtins) concatStringsSep removeAttrs;
    inherit (flake.lib) lua;
    adaptersList =
      lib.mapAttrsToList (
        name: value: let
          inherit (value) extend;
          adapter = lua ((removeAttrs value ["extend"]) // {inherit name;});
        in
          # lua
          ''
            ${name} = function()
              return require("codecompanion.adapters").extend("${extend}", ${adapter})
            end,
          ''
      )
      adapters;
  in
    lua
    # lua
    ''
      {
        opts = ${lua opts},
        ${concatStringsSep "\n" adaptersList}
      }
    '';
in {
  options.vim.assistant.codecompanion-nvim = {
    adapters = mkOption {
      type = attrs;
      default = {};
      example = {
        ollama_qwen3 = {
          extend = "ollama";
          env.url = "http://127.0.0.1:11434";
          headers."Content-Type" = "application/json";
          parameters.sync = true;
          schema = {
            model.default = "qwen3:30b-a3b";
            temperature.default = 0.6;
            top_p.default = 0.95;
            top_k.default = 20;
            min_p.default = 0;
          };
        };
      };
    };
    adapterOpts = mkOption {
      type = attrs;
      default = {};
      example = {
        show_defaults = false;
      };
    };
    dependencies = mkOption {
      type = listOf package;
      default = [];
    };
  };

  config.vim.assistant.codecompanion-nvim = {
    setupOpts.adapters = luaAdapters cfg.adapters cfg.adapterOpts;
  };
}
