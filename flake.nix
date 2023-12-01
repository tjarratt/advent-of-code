{
  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in
    {
      devShells.aarch64-darwin.default = pkgs.mkShell
        {
          packages = [ pkgs.elixir pkgs.elixir_ls ];
        };
    };
}
