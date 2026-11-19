{
  pkgs,
  lib,
  inputs,
  ...
}: let
  tape = pkgs.runCommand "featured-tape-end-4" {} ''
    mkdir -p "$out"
    if [ -d "${inputs.end-4-dots}/dots/.config" ]; then
      cp -r "${inputs.end-4-dots}/dots/.config/"* "$out/"
    fi

    grep -v '^install =' ${./tape.toml} > "$out/tape.toml"
  '';
in {
  name = "end-4";
  inherit tape;

  packages = with pkgs; [
    quickshell
    hypridle
    hyprlock
    hyprpicker
    hyprshot
    hyprsunset
    wl-clipboard
    cliphist
    fuzzel
    wlogout
    slurp
    swappy
    wf-recorder
    tesseract
    cava
    playerctl
    brightnessctl
    ddcutil
    wtype
    ydotool
    bc
    jq
    ripgrep
    rsync
    yq-go
    fish
    kitty
    starship
    eza
    matugen
    material-symbols
    rubik
    twemoji-color-font
    nerd-fonts.jetbrains-mono
    adw-gtk3
    bibata-cursors
  ];

  env = {};
}
