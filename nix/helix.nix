# Wrapped helix, includes my configs and the tools needed for them
{pkgs, ...}: let
  printConfig = {
    name,
    cfg,
  }:
    import ./printConfig.nix {inherit pkgs name cfg;};
  configs = ../configs/editor/helix;
  printCfg = printConfig {
    name = "hx-print-cfg";
    cfg = "${configs}/config.toml";
  };
  printLanguages = printConfig {
    name = "hx-print-languages";
    cfg = "${configs}/languages.toml";
  };

  runtimeEnv = pkgs.buildEnv {
    name = "hx-runtime-env";
    paths = with pkgs;
      [
        # Nix
        alejandra
        nil
        nixd
        # Python
        ruff
        basedpyright
        # Yaml/json
        biome
        yaml-language-server
        vscode-json-languageserver
        # Other
        nushell
      ]
      ++ [printCfg printLanguages];
  };
  ln = "${pkgs.coreutils}/bin/ln";

  wrapper-builder =
    # nu
    ''
      mkdir ($env.out + "/bin") ($env.out + "/helix")

      ${ln} -s "${pkgs.helix}/share" ($env.out + "/share")
      ${ln} -s "${pkgs.helix}/bin" ($env.out + "/bin")

      ${ln} -s ${configs}/config.toml ($env.out + "/helix/config.toml")
      ${ln} -s ${configs}/languages.toml ($env.out + "/helix/languages.toml")

      let wrapperText = ${pkgs.coreutils}/bin/cat $env.wrapperPath
      "#!${pkgs.nushell}/bin/nu\n" + ("$env.XDG_CONFIG_HOME = \"" + $env.out + "\"\n") + $wrapperText o> ($env.out + "/bin/hx")

      ${pkgs.coreutils}/bin/chmod +x ($env.out + "/bin/hx")
    '';
in
  builtins.derivation {
    pname = "hx";
    name = "helix-wrapped";
    inherit (pkgs.stdenv.hostPlatform) system;
    builder = "${pkgs.nushell}/bin/nu";
    args = [
      "-c"
      wrapper-builder
    ];
    passAsFile = ["wrapper"];
    wrapper =
      # nu
      ''
        def --wrapped main [...args] {
          $env.Path = ($env.Path | prepend "${runtimeEnv}/bin")
          ${pkgs.helix}/bin/hx ...$args
        }
      '';
  }
