{
  pkgs,
  lib,
  inputs,
  ...
}: let
  tape = pkgs.runCommand "featured-tape-serpantinum" {} ''
    mkdir -p "$out/serpantinum-shell"
    for item in bin src version.txt; do
      if [ -e "${inputs.serpantinum-dots}/$item" ]; then
        cp -r "${inputs.serpantinum-dots}/$item" "$out/serpantinum-shell/$item"
      fi
    done
    if [ -d "${inputs.serpantinum-dots}/compositors/hyprland" ]; then
      cp -r "${inputs.serpantinum-dots}/compositors/hyprland" "$out/hypr"
    fi
    if [ -d "${inputs.serpantinum-dots}/config/kitty" ]; then
      cp -r "${inputs.serpantinum-dots}/config/kitty" "$out/kitty"
    fi

    grep -v '^install =' ${./tape.toml} > "$out/tape.toml"
  '';
in {
  name = "serpantinum";
  inherit tape;

  packages = with pkgs; [
    quickshell
    matugen
    wl-clipboard
    cliphist
    jq
    kitty
  ];

  env = {};
}
