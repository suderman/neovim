{flake, ...}: let
  inherit (flake.lib) lua;
in {
  vim.assistant.codecompanion-nvim = {
    adapters = {
      openrouter = {
        extend = "openai_compatible";
        env.url = "https://openrouter.ai/api";
        env.api_key = "OPENROUTER_API_KEY";
        schema.model = rec {
          choices = [
            "openai/gpt-4.1"
            "anthropic/claude-sonnet-4"
            "google/gemini-2.5-flash"
            "google/gemini-2.0-flash-exp:free"
            "qwen/qwen3-30b-a3b:free"
            "qwen/qwq-32b:free"
          ];
          default = builtins.head choices;
        };
      };
      ollama = {
        extend = "ollama";
        env.url = "http://10.1.0.6:11434";
        headers."Content-Type" = "application/json";
        parameters.sync = true;
        opts.vision = true;
        opts.stream = true;
        schema = rec {
          model.choices = [
            "qwen3:8b"
            "qwen3:30b-a3b"
            "qwen2.5-coder:7b"
            "mistral:7b-instruct"
          ];
          model.default = builtins.head model.choices;
          temperature.default = 0.6;
          top_p.default = 0.95;
          top_k.default = 20;
          min_p.default = 0;
          num_ctx.default = 16384;
          think.default = false;
          keep_alive.default = "5m";
        };
      };
      copilot = {
        extend = "copilot";
      };
      tavily = {
        extend = "tavily";
        env.api_key = "TAVILY_API_KEY";
      };
    };
    adapterOpts.show_defaults = false;
    adapterOpts.show_model_choices = true;
  };
  vim.assistant.copilot.cmp.enable = true;
}
