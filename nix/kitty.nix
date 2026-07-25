{pkgs}: let
  font = pkgs.makeFontsConf {fontDirectories = [pkgs.lilex];};
  config = ../configs/terminal/kitty/kitty.conf;
in
  pkgs.symlinkJoin {
    name = "kitty";
    paths = [pkgs.kitty];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      ln -s ${config} $out/kitty.conf
      wrapProgram $out/bin/kitty \
        --set FONTCONFIG_FILE ${font} \
        --set KITTY_CONFIG_DIRECTORY $out
    '';
  }
