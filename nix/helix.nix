# Wrapped helix, includes my configs and the tools needed for them
{pkgs}: let
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
    paths = with pkgs; [
      # Nix
      alejandra
      nil
      nixd
      # Rust
      rust-analyzer
      rustfmt
      # Python
      ruff
      basedpyright
      # Yaml/json
      biome
      yaml-language-server
      vscode-json-languageserver
      # Other
      nushell
    ];
  };
in
  pkgs.symlinkJoin {
    name = "helix";
    paths = [
      pkgs.helix
      printCfg
      printLanguages
    ];
    nativeBuildInputs = [pkgs.makeWrapper];
    # Best way to wrap the languages is to set XDG_CONFIG_HOME to the output dir
    postBuild = ''
      mkdir -p $out/helix
      ln -s ${configs}/config.toml $out/helix/config.toml
      ln -s ${configs}/languages.toml $out/helix/languages.toml
      wrapProgram $out/bin/hx --prefix PATH : ${runtimeEnv}/bin \
        --set XDG_CONFIG_HOME $out
    '';
    meta.mainProgram = "bin/hx";
  }
