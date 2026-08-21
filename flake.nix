{
  description = "Michael's Rootbeer Configs";
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    rush.url = "github:michael-c-buckley/rush/nix";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    forAllSystems = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
    p = forAllSystems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
  in {
    devShells = forAllSystems (
      system: {
        default = import ./nix/shell.nix {pkgs = p.${system};};
      }
    );
    packages = forAllSystems (
      system:
        builtins.listToAttrs (map (n: {
          name = n;
          value = p.${system}.callPackage ./nix/${n}.nix {
            inherit inputs;
          };
        }) ["fish" "nushell" "helix" "kitty" "rush" "zsh"])
    );
  };
}
