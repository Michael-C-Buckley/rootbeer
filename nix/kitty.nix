{
  pkgs,
  extraConf ? '''',
  fonts ? [pkgs.lilex],
  paths ? [pkgs.kitty],
  ...
}: let
  font = pkgs.makeFontsConf {fontDirectories = fonts;};
  config = ../configs/terminal/kitty/kitty.conf;
  # My default, unless I override
  optionsFile = ''
    font_family family='Lilex Nerd Font' style=Medium
    font_size 11
  '';
  mkWrapper = path: ''
    wrapProgram ${path} \
      --set FONTCONFIG_FILE ${font} \
      --set KITTY_CONFIG_DIRECTORY $out
  '';
in
  pkgs.symlinkJoin {
    name = "kitty";
    inherit paths;
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild =
      ''
        ln -s ${config} $out/kitty.conf

        mkdir -p "$out/kitty.d/nix"
        printf '%s' ${pkgs.lib.escapeShellArg optionsFile} \
          > "$out/kitty.d/nix/98_nix_default.conf"

        printf '%s' ${pkgs.lib.escapeShellArg extraConf} \
          > "$out/kitty.d/nix/99_extra.conf"

        ${mkWrapper "$out/bin/kitty"}
      ''
      + (
        if pkgs.stdenv.isDarwin
        then mkWrapper "$out/Applications/kitty.app/Contents/MacOS/kitty"
        else ""
      );
  }
