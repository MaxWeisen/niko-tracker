{
  description = "Niko Tracker - GPS dog (or anything!) tracking system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell{
          buildInputs = with pkgs; [
            # Go backend
            go
            gopls

            # Node/Typescript frontend
            nodejs_22
            nodePackages.typescript

            # Protobuf tooling
            protobuf
            buf
            protoc-gen-go
            protoc-gen-go-grpc

            # Database
            postgresql_16
            
            # Utilities
            jq
            curl
          ];

          shellHook = ''
            export PATH="$PWD/node_modules/.bin:$PATH"
            echo "Niko Tracker dev environment loaded"
            echo "Go: $(go version)"
            echo "Node: $(node --version)"
            echo "Buf: $(buf --version)"
          '';
        };
      });
}