{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    rust-overlay,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];

    eachSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (
        system: let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              (import rust-overlay)
            ];
          };
        in
          f pkgs
      );
  in {
    packages = eachSystem (pkgs: {
      default = pkgs.callPackage ./default.nix {};
      # rustToolchain = pkgs.rust-bin.stable."1.77.2".default;
      rustToolchain = pkgs.rust-bin.stable.latest.default;
    });

    # Used by `nix develop` or `direnv` to open a devShell
    devShells = eachSystem (pkgs: {
      default = pkgs.mkShell {
        # Extra inputs can be added here
        nativeBuildInputs = with pkgs; [
          cargo-audit
          cargo-nextest
          cargo-outdated
          cargo-watch
          rust-analyzer
          self.packages.${system}.rustToolchain
        ];
      };
    });
  };
}
