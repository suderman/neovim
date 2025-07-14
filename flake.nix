{
  description = "my nvf neovim flake";

  inputs = {
    # Nix Packages
    # <https://search.nixos.org/packages>
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Map folder structure to flake outputs
    # <https://github.com/numtide/blueprint>
    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";

    # Developer environments
    # <https://github.com/numtide/devshell>
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";

    # Neovim
    # <https://notashelf.github.io/nvf>
    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    # <https://github.com/olimorris/codecompanion.nvim>
    codecompanion-nvim.url = "github:olimorris/codecompanion.nvim";
    codecompanion-nvim.flake = false;

    # <https://ravitemer.github.io/mcphub.nvim>
    mcphub-nvim.url = "github:ravitemer/mcphub.nvim";
    mcphub-nvim.inputs.nixpkgs.follows = "nixpkgs";

    # <https://github.com/ravitemer/mcp-hub>
    mcp-hub.url = "github:ravitemer/mcp-hub";
    mcp-hub.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    inherit
      (inputs.blueprint {inherit inputs;})
      devShells
      packages
      formatter
      checks
      lib
      ;
  };
}
