{
  description = "nix flake for beautiful_me minetest mod";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };

  outputs = { self, nixpkgs }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = [
              # Checking and linting
              pkgs.nixd
              pkgs.luajitPackages.luacheck

              # Count LOC
              pkgs.scc
            ];
          };
        });
    };
}
