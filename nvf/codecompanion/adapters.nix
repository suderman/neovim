{flake, ...}: let
  inherit (flake.lib) lua;
in {
  vim.assistant.codecompanion-nvim = {
    adapters = {
      # # local inline
      # ollama_mistral = {
      #   extend = "ollama";
      #   env.url = "http://10.1.0.6:11434";
      #   headers."Content-Type" = "application/json";
      #   parameters.sync = true;
      #   schema.model.default = "mistral:7b-instruct";
      # };
      # # local chat
      # ollama_qwen3 = {
      #   extend = "ollama";
      #   env.url = "http://10.1.0.6:11434";
      #   headers."Content-Type" = "application/json";
      #   parameters.sync = true;
      #   schema = {
      #     model.default = "qwen3:30b-a3b";
      #     temperature.default = 0.6;
      #     top_p.default = 0.95;
      #     top_k.default = 20;
      #     min_p.default = 0;
      #   };
      # };
      # # paid inline
      # openrouter_gemini25_flash = {
      #   extend = "openai_compatible";
      #   env.url = "https://openrouter.ai/api";
      #   env.api_key = "OPENROUTER_API_KEY";
      #   schema.model.default = "google/gemini-2.5-flash";
      # };
      # # paid chat
      # openrouter_claude35_sonnet = {
      #   extend = "openai_compatible";
      #   env.url = "https://openrouter.ai/api";
      #   env.api_key = "OPENROUTER_API_KEY";
      #   schema.model.default = "anthropic/claude-3.5-sonnet";
      # };
      # # paid chat
      # openrouter_claude37_sonnet = {
      #   extend = "openai_compatible";
      #   env.url = "https://openrouter.ai/api";
      #   env.api_key = "OPENROUTER_API_KEY";
      #   schema.model.default = "anthropic/claude-3.7-sonnet";
      # };
      tavily = {
        extend = "tavily";
        env.api_key = "TAVILY_API_KEY";
      };
      openrouter = {
        extend = "openai_compatible";
        env.url = "https://openrouter.ai/api";
        env.api_key = "OPENROUTER_API_KEY";
        schema.model = {
          default = "anthropic/claude-3.5-sonnet";
          choices = [
            "anthropic/claude-3.5-sonnet"
            "anthropic/claude-3.7-sonnet"
            "google/gemini-2.5-flash"
          ];
        };
      };
      ollama = {
        extend = "ollama";
        env.url = "http://10.1.0.6:11434";
        headers."Content-Type" = "application/json";
        parameters.sync = true;
        schema.model = {
          default = "qwen2.5-coder:7b";
          choices = [
            "qwen2.5-coder:7b"
            "qwen3:30b-a3b"
            "mistral:7b-instruct"
          ];
        };
      };
    };
    adapterOpts.show_defaults = false;
    adapterOpts.show_model_choices = true;
  };
}
