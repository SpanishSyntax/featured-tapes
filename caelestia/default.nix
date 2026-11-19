{
  pkgs,
  lib,
  inputs,
  system,
  ...
}: let
  caelestiaShell =
    if inputs.caelestia-shell.packages.${system} ? with-cli
    then inputs.caelestia-shell.packages.${system}.with-cli
    else inputs.caelestia-shell.packages.${system}.default;

  tape = pkgs.runCommand "featured-tape-caelestia" {} ''
    mkdir -p "$out"
    for item in btop fastfetch fish foot hypr micro starship.toml thunar; do
      if [ -e "${inputs.caelestia-dots}/$item" ]; then
        cp -r "${inputs.caelestia-dots}/$item" "$out/$item"
      fi
    done

    # Strip imperative Arch setup.sh install hook; Nix supplies runtime dependencies declaratively.
    grep -v '^install =' ${./tape.toml} > "$out/tape.toml"
  '';
in {
  name = "caelestia";
  inherit tape;

  packages = with pkgs; [
    caelestiaShell
    ddcutil
    brightnessctl
    cava
    swappy
    fish
    cliphist
    wl-clipboard
    fuzzel
    ydotool
    hyprpicker
    hyprcursor
    material-symbols
    rubik
    nerd-fonts.caskaydia-cove
  ];

  env = {};
}
