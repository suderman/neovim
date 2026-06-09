{
  description = "suderman's neovim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    # https://github.com/sudo-tee/opencode.nvim
    opencode-nvim.url = "github:sudo-tee/opencode.nvim";
    opencode-nvim.flake = false;

    # https://github.com/amrbashir/nvim-docs-view
    nvim-docs-view.url = "github:amrbashir/nvim-docs-view";
    nvim-docs-view.flake = false;
  };

  outputs = inputs: let
    neovim-overlay = import ./nix/neovim-overlay.nix {inherit inputs;};
  in
    inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          neovim-overlay
          inputs.gen-luarc.overlays.default
        ];
        config = {
          allowUnfree = true;
        };
      };
      treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      shell = pkgs.mkShell {
        name = "nvim-devShell";
        buildInputs = with pkgs; [
          treefmtEval.config.build.wrapper
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
      formatter = treefmtEval.config.build.wrapper;
      devShells = {
        default = shell;
      };
    })
    // {
      overlays.default = neovim-overlay;
    };
}
