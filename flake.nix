{
  description = "suderman's neovim flake";

  inputs = {
    # Using stable branch; nixos-25.11 has nvf compatibility issues:
    # https://github.com/NotAShelf/nvf/issues/1312
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";

    # Neovim plugins from git
    codecompanion-nvim.url = "github:olimorris/codecompanion.nvim";
    codecompanion-nvim.flake = false;

    codecompanion-spinner-nvim.url = "github:franco-ruggeri/codecompanion-spinner.nvim";
    codecompanion-spinner-nvim.flake = false;

    codecompanion-lualine-nvim.url = "github:franco-ruggeri/codecompanion-lualine.nvim";
    codecompanion-lualine-nvim.flake = false;

    mcphub-nvim.url = "github:ravitemer/mcphub.nvim";
    mcphub-nvim.inputs.nixpkgs.follows = "nixpkgs";

    nvim-docs-view.url = "github:amrbashir/nvim-docs-view";
    nvim-docs-view.flake = false;

    mcp-hub.url = "github:ravitemer/mcp-hub";
    mcp-hub.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: let
    systems = builtins.attrNames nixpkgs.legacyPackages;

    neovim-overlay = import ./nix/neovim-overlay.nix { inherit inputs; };
  in
    flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          neovim-overlay
          inputs.gen-luarc.overlays.default
        ];
        config = {
          allowUnfree = true;
        };
      };
      shell = pkgs.mkShell {
        name = "nvim-devShell";
        buildInputs = with pkgs; [
          lua-language-server
          nil
          stylua
          luajitPackages.luacheck
          nvim-dev
        ];
        shellHook = ''
          ln -fs ${pkgs.nvim-luarc-json} .luarc.json
          ln -Tfns $PWD/nvim ~/.config/nvim-dev
        '';
      };
    in {
      packages = rec {
        default = nvim;
        nvim = pkgs.nvim-pkg;
      };
      devShells = {
        default = shell;
      };
    })
    // {
      overlays.default = neovim-overlay;
    };
}
