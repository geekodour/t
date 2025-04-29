{
  description = "go app";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devshell = {
      url =
        "github:numtide/devshell"; # it adds few helper env vars, see documentation
      inputs.nixpkgs.follows = "nixpkgs";
    };
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devshell.flakeModule
        # https://community.flake.parts/process-compose-flake
        inputs.process-compose-flake.flakeModule
      ];
      systems = [ "x86_64-linux" ];
      perSystem = { config, self', inputs', pkgs, lib, system, ... }: {

        config.devshells.default = {
          name = "go-shell";
          env = [{
            name = "GOROOT";
            value = pkgs.go + "/share/go";
          }];

          # NOTE: DO NOT REMOVE
          # devshell.startup = {
          #   dummy_debug = { text = "echo ${builtins.getEnv "PRJ_DATA_DIR"}"; };
          # };

          motd = ''
            ┈┈┈┈▕▔╱▔▔▔━▁
            ┈┈┈▕▔╱╱╱👁┈╲▂▔▔╲
            ┈┈▕▔╱╱╱╱💧▂▂▂▂▂▂▏
            ┈▕▔╱▕▕╱╱╱┈▽▽▽▽▽
            ▕▔╱┊┈╲╲╲╲▂△△△△
            ▔╱┊┈╱▕╲▂▂▂▂▂▂╱
            ╱┊┈╱┉▕┉┋╲┈
            LET'S GOOO
          '';

          packages = with lib;
            mkMerge [[
              # golang
              pkgs.go
              pkgs.gotestsum
              pkgs.gofumpt
              pkgs.golangci-lint

              # postgres
              pkgs.postgresql_16
            ]];
        };

        # NOTE: demo use of process-compose with pg
        config.process-compose = {
          dev = {
            settings.processes = {
              postgres-server = {
                command = ''
                  pg_ctl -o "-p 7777 -k $PRJ_DATA_DIR/pg_sock" -D $PRJ_DATA_DIR/pg start'';
                is_daemon = true;
                shutdown = {
                  command = ''
                    pg_ctl -o "-p 7777 -k $PRJ_DATA_DIR/pg_sock" -D $PRJ_DATA_DIR/pg stop'';
                };
              };
            };
          };
        };

      };

      # Usual flake attributes if any
      flake = { };
    };
}
