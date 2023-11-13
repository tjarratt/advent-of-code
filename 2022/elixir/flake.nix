{
  description = "Elixir on Sonoma";

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      beamPkgs = pkgs.beam.packages.erlang_26;
    in
    {
      devShells.aarch64-darwin.default = pkgs.mkShell {
        buildInputs = with
          [
            pkgs.darwin.apple_sdk.frameworks
          ];
          [
            beamPkgs.elixir_1_15
            pkgs.sqlite
            Foundation
            CoreServices
            AppKit
          ];

      };

      apps.aarch64-darwin.iex = {
        type = "app";
        program = "${beamPkgs.elixir_1_15}/bin/iex";
      };

      apps.aarch64-darwin.mix = {
        type = "app";
        program = "${beamPkgs.elixir_1_15}/bin/mix";
      };

      packages.aarch64-darwin.default = beamPkgs.elixir_1_15;
    };
}
