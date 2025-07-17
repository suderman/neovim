{...}: {
  vim.assistant.codecompanion-nvim.setupOpts.prompt_library = {
    "think-on" = {
      strategy = "chat";
      description = "Enable thinking";
      opts.mapping = "gK";
      prompts = [
        {
          role = "user";
          content = "/set think";
        }
      ];
    };
    "think-off" = {
      strategy = "chat";
      description = "Disbale thinking";
      opts.mapping = "gk";
      prompts = [
        {
          role = "user";
          content = "/set nothink";
        }
      ];
    };
  };
}
