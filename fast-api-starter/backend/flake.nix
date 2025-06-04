{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    nixpkgs,
    uv2nix,
    pyproject-nix,
    pyproject-build-systems,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      perSystem = { config, pkgs, ... }:
        let
          pyPackages = pkgs.python312Packages;
          python = pkgs.python312;

          pyprojectOverrides = final: prev: {};

          # uv2nix stuff
          uvworkspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };
          uvlockoverlay = uvworkspace.mkPyprojectOverlay {sourcePreference = "wheel";};
          uvpythonSet = (
            pkgs.callPackage pyproject-nix.build.packages { inherit python; }
          ).overrideScope(nixpkgs.lib.composeManyExtensions [
            pyproject-build-systems.overlays.default # for build tools
            uvlockoverlay                            # locked dependencies
            pyprojectOverrides                       # custom
          ]);
        in
        {
          packages = rec {
            pasoli_be = uvpythonSet.mkVirtualEnv "pasoli-env" uvworkspace.deps.default;
            pasoli_be_docker = pkgs.dockerTools.buildLayeredImage {
              name = builtins.getEnv "IMAGE_NAME";
              tag = builtins.getEnv "IMAGE_TAG";
              contents = [
                  pasoli_be
                  pkgs.cacert
                  pkgs.bashInteractive
                  pkgs.coreutils
              ];
              config = {
                Cmd = [ "./bin/pasoli_server" ];
                Env = [
                  "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
                  # https://github.com/NixOS/nix/issues/795
                ];
              };
            };
          };
          devShells = {
            ci = pkgs.mkShell {
              name = "ci";
              packages = [
                pkgs.just
                pkgs.python312
                pkgs.uv
              ];
            };
            default = pkgs.mkShell {
              name = "pasoli";
              buildInputs = [
                pkgs.python312
                pkgs.uv
              ];
              nativeBuildInputs = [];
              packages = [
                pyPackages.pudb
                pyPackages.ipython
                pyPackages.isort
                pyPackages.mypy
                pkgs.ruff

                # others
                # pkgs.sqlc
                # pkgs.meilisearch
                # pkgs.rclone
                # pkgs.postgresql_17
              ];
              shellHook = ''
                 uv sync
                 source .venv/bin/activate
              '';
              # postShellHook = ''
              #   export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [pkgs.stdenv.cc.cc]}"
              # '';
            };
          };
        };
    };
}
