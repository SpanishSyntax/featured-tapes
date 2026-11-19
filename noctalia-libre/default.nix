{
  pkgs,
  lib,
  inputs,
  ...
}: let
  tape = pkgs.runCommand "featured-tape-noctalia-libre" {} ''
    mkdir -p "$out"
    for item in btop foot helix hypr mango noctalia; do
      if [ -e "${inputs.noctalia-libre-dots}/$item" ]; then
        cp -r "${inputs.noctalia-libre-dots}/$item" "$out/$item"
      fi
    done

    grep -v '^install =' ${./tape.toml} > "$out/tape.toml"
  '';
in {
  name = "noctalia-libre";
  inherit tape;

  packages = with pkgs; [
    (pkgs.noctalia or pkgs.noctalia-shell)
    mangowc
    foot
    btop
    helix
    bibata-cursors
    wl-clipboard
    hyprpicker
  ];

  env = {};
}
