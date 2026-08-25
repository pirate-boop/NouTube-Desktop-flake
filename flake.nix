{
  description = "Standalone Nix Flake for NouTube Desktop powered by nvfetcher";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      # Clean overlay for importing into system NixOS config
      overlays.default = final: prev: {
        noutube =
          let
            sources = final.callPackage ./_sources/generated.nix { };
          in
          final.callPackage ./pkgs/noutube/default.nix { inherit sources; };
      };

      # Standalone package outputs
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
          sources = pkgs.callPackage ./_sources/generated.nix { };
        in
        {
          noutube = pkgs.callPackage ./pkgs/noutube/default.nix { inherit sources; };
          default = self.packages.${system}.noutube;
        }
      );

      # Devshell providing nvfetcher for updating sources
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = [ pkgs.nvfetcher ];
          };
        }
      );
    };
}
