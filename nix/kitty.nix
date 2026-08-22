{
  pkgs,
  extraConf ? '''',
  fonts ? [pkgs.lilex],
  paths ? [pkgs.kitty],
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  font = pkgs.makeFontsConf {fontDirectories = fonts;};
  config = ../configs/terminal/kitty/kitty.conf;
  # My default, unless I override
  optionsFile = ''
    font_family family='Lilex Nerd Font' style=Medium
    font_size 11
  '';
  macApp = "$out/Applications/kitty.app";
  macExe = "${macApp}/Contents/MacOS/kitty";
in
  pkgs.symlinkJoin {
    name = "kitty";
    inherit paths;
    nativeBuildInputs =
      [pkgs.makeBinaryWrapper]
      ++ pkgs.lib.optionals isDarwin [pkgs.darwin.autoSignDarwinBinariesHook];
    postBuild =
      ''
        ln -s ${config} $out/kitty.conf

        mkdir -p "$out/kitty.d/nix"
        printf '%s' ${pkgs.lib.escapeShellArg optionsFile} \
          > "$out/kitty.d/nix/98_nix_default.conf"

        printf '%s' ${pkgs.lib.escapeShellArg extraConf} \
          > "$out/kitty.d/nix/99_extra.conf"
      ''
      + (
        if isDarwin
        then ''
          # Keep a single wrapper at the executable named by Info.plist. The
          # Darwin signing hook signs this Mach-O during fixup, and the CLI
          # entry point resolves to the same signed file.
          original=$(readlink -f "$out/bin/kitty")
          rm "$out/bin/kitty" "${macExe}"

          makeBinaryWrapper "$original" "${macExe}" \
            --set FONTCONFIG_FILE ${font} \
            --set KITTY_CONFIG_DIRECTORY $out

          ln -s ../Applications/kitty.app/Contents/MacOS/kitty "$out/bin/kitty"
        ''
        else ''
          wrapProgram "$out/bin/kitty" \
            --set FONTCONFIG_FILE ${font} \
            --set KITTY_CONFIG_DIRECTORY $out
        ''
      );
  }
