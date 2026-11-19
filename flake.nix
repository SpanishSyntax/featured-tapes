{
  description = "Official curated rices for Tapes v2, with declarative NixOS & Home Manager support";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    caelestia-dots = {
      url = "github:caelestia-dots/caelestia";
      flake = false;
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    end-4-dots = {
      url = "github:end-4/dots-hyprland";
      flake = false;
    };
    nebula-dots = {
      url = "github:LilaccFlowerr/Nebula";
      flake = false;
    };
    m3shapes = {
      url = "github:soramanew/m3shapes";
      flake = false;
    };
    noctalia-libre-dots = {
      url = "github:futurekismo-oss/noctalia-libre";
      flake = false;
    };
    serpantinum-dots = {
      url = "github:ilyamiro/serpantinum";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    riceNames = [
      "caelestia"
      "end-4"
      "nebula"
      "noctalia-libre"
      "serpantinum"
    ];

    loadRices = system: pkgs:
      nixpkgs.lib.genAttrs riceNames (name:
        import ./${name}/default.nix {
          inherit pkgs inputs system;
          lib = pkgs.lib;
        });

    mkHomeModule = defaultEnabled: {
      config,
      lib,
      pkgs,
      ...
    }: let
      cfg = config.programs.featured-tapes;
      system = pkgs.stdenv.hostPlatform.system;
      rices = loadRices system pkgs;
      selected = map (name: rices.${name}) cfg.tapes;
    in {
      options.programs.featured-tapes = {
        enable = lib.mkEnableOption "Declarative featured tapes and their Nix runtime dependencies";

        tapes = lib.mkOption {
          type = lib.types.listOf (lib.types.enum riceNames);
          default = defaultEnabled;
          example = ["caelestia" "nebula" "noctalia-libre"];
          description = "Featured tapes to materialize into `~/.tapes/<name>` along with their Nix runtime packages.";
        };
      };

      config = lib.mkIf (cfg.enable && cfg.tapes != []) {
        home.packages = lib.concatMap (r: r.packages) selected;

        home.sessionVariables =
          lib.zipAttrsWith (_: values: lib.concatStringsSep ":" (lib.unique values)) (map (r: r.env) selected);

        home.file = lib.listToAttrs (map (r: {
            name = ".tapes/${r.name}";
            value = {
              source = r.tape;
              recursive = true;
            };
          })
          selected);
      };
    };
  in
    flake-utils.lib.eachSystem ["x86_64-linux" "aarch64-linux"] (system: let
      pkgs = import nixpkgs {inherit system;};
      rices = loadRices system pkgs;

      tapePackages = nixpkgs.lib.mapAttrs' (name: r: {
        name = "${name}-tape";
        value = r.tape;
      }) rices;

      envPackages = nixpkgs.lib.mapAttrs (name: r:
        pkgs.symlinkJoin {
          name = "featured-tape-${name}-deps";
          paths = r.packages;
        })
      rices;
    in {
      packages = tapePackages // envPackages;

      devShells = nixpkgs.lib.mapAttrs (name: r:
        pkgs.mkShell {
          name = "tape-${name}";
          packages = r.packages;
          shellHook = ''
            ${nixpkgs.lib.concatStringsSep "\n" (nixpkgs.lib.mapAttrsToList (k: v: ''export ${k}="${v}''${${k}:+:''$${k}}"'') r.env)}
            echo "Featured tape '${name}' runtime environment loaded."
            echo "Try it with: tapes insert -p ${r.tape}"
          '';
        })
      rices;
    })
    // {
      lib = {
        inherit riceNames loadRices;
      };

      homeManagerModules =
        {
          default = mkHomeModule [];
        }
        // nixpkgs.lib.genAttrs riceNames (name: {
          imports = [self.homeManagerModules.default];
          programs.featured-tapes = {
            enable = nixpkgs.lib.mkDefault true;
            tapes = [name];
          };
        });
    };
}
