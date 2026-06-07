{
  description = "suderman's neovim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";

    # Neovim plugins from git
    opencode-nvim.url = "github:sudo-tee/opencode.nvim";
    opencode-nvim.flake = false;

    nvim-docs-view.url = "github:amrbashir/nvim-docs-view";
    nvim-docs-view.flake = false;

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
