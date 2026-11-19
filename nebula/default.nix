{
  pkgs,
  lib,
  inputs,
  ...
}: let
  m3shapes = pkgs.stdenv.mkDerivation {
    pname = "m3shapes";
    version = "1.0.0";
    src = inputs.m3shapes;

    nativeBuildInputs = [
      pkgs.cmake
      pkgs.ninja
      pkgs.qt6.wrapQtAppsHook
    ];

    buildInputs = [
      pkgs.qt6.qtbase
      pkgs.qt6.qtdeclarative
      pkgs.qt6.qtshadertools
    ];

    dontWrapQtApps = true;

    cmakeFlags = [
      "-DM3SHAPES_BUILD_EXAMPLES=OFF"
    ];

    meta = {
      description = "Material 3 Expressive shapes QML plugin for Qt6";
      homepage = "https://github.com/soramanew/m3shapes";
      platforms = lib.platforms.linux;
    };
  };

  tape = pkgs.runCommand "featured-tape-nebula" {} ''
    mkdir -p "$out"
    for item in hypr quickshell matugen ghostty; do
      if [ -e "${inputs.nebula-dots}/$item" ]; then
        cp -r "${inputs.nebula-dots}/$item" "$out/$item"
      fi
    done

    grep -v '^install =' ${./tape.toml} > "$out/tape.toml"
  '';
in {
  name = "nebula";
  inherit tape;

  packages = with pkgs; [
    quickshell
    m3shapes
    matugen
    ghostty
    material-symbols
    papirus-icon-theme
    qt6.qtdeclarative
    qt6.qtshadertools
  ];

  env = {
    QML2_IMPORT_PATH = "${m3shapes}/lib/qt6/qml";
  };
}
