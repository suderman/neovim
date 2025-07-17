{flake, ...}: let
  inherit (flake.lib) lua;
in {
  vim.assistant.codecompanion-nvim.setupOpts.display = {
    chat = {
      auto_scroll = true;
      intro_message = "Welcome to CodeCompanion ✨! Press ? for options";
      show_header_separator = false; # Show header separators in the chat buffer?
      separator = "─"; # The separator between the different messages in the chat buffer
      show_references = true; # Show references (from slash commands and variables) in the chat buffer?
      show_settings = false; # Show LLM settings at the top of the chat buffer?
      show_token_count = true; # Show the token count for each response?
      start_in_insert_mode = false; # Open the chat buffer in insert mode?
    };
    action_palette = {
      width = 95;
      height = 10;
      prompt = "Prompt "; # Prompt used for interactive LLM calls
      provider = "default"; # snacks
      opts = {
        show_default_actions = true; # Show the default actions in the action palette?
        show_default_prompt_library = true; # Show the default prompt library in the action palette?
      };
    };
    diff = {
      enabled = true;
      close_chat_at = 240; # Close an open chat buffer if the total columns of your display are less than...
      layout = "vertical"; # vertical|horizontal split for default provider
      opts = ["internal" "filler" "closeoff" "algorithm:patience" "followwrap" "linematch:120"];
      provider = "mini_diff"; # default|mini_diff
    };
  };

  vim.mini.diff = {
    enable = true;
    setupOpts.source = lua "require('mini.diff').gen_source.none()";
  };

  vim.languages.markdown.extensions.render-markdown-nvim.setupOpts.file_types = [
    "codecompanion"
  ];

  vim.autocomplete.blink-cmp.setupOpts.sources.per_filetype = {
    codecompanion = ["codecompanion"];
  };
}
