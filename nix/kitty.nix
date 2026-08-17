{pkgs, ...}: let
  font = pkgs.makeFontsConf {fontDirectories = [pkgs.lilex];};
  config = ../configs/terminal/kitty/kitty.conf;
  # Shim to write options until I declare an override
  optionsFile = ''
    font_family family='Lilex Nerd Font' style=Medium
    font_size 11
  '';
in
  pkgs.symlinkJoin {
    name = "kitty";
    paths = [pkgs.kitty];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      ln -s ${config} $out/kitty.conf

      mkdir -p "$out/kitty.d/nix"
      printf '%s' ${pkgs.lib.escapeShellArg optionsFile} \
        > "$out/kitty.d/nix/99_options.conf"

      wrapProgram $out/bin/kitty \
        --set FONTCONFIG_FILE ${font} \
        --set KITTY_CONFIG_DIRECTORY $out
    '';
  }
