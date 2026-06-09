{
  projectRootFile = "flake.nix";

  programs.alejandra = {
    enable = true;
    includes = [
      "*.nix"
      "**/*.nix"
    ];
  };

  programs.stylua = {
    enable = true;
    includes = [
      "*.lua"
      "**/*.lua"
    ];
  };

  programs.prettier = {
    enable = true;
    includes = [
      "*.md"
      "**/*.md"
    ];
  };
}
