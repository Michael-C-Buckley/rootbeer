# Wrapped nushell
{pkgs}: let
  shellEnv = import ./shellEnv.nix {inherit pkgs;};
  printConfig = {
    name,
    cfg,
  }:
    import ./printConfig.nix {inherit pkgs name cfg;};


  # Nushell configs from the other part of this repo
  configs = ../configs/shells/nushell;

  printCfg = printConfig {
    name = "nu-print-cfg";
    cfg = "${configs}/config.nu";
  };
  printEnv = printConfig {
    name = "nu-print-env";
    cfg = "${configs}/env.nu";
  };

  runtimeEnv = pkgs.buildEnv {
    name = "nushell-env";
    paths = builtins.attrValues {
      inherit shellEnv printCfg printEnv;
      inherit (pkgs) fish carapace;
    };
  };
in
  pkgs.symlinkJoin {
    name = "nushell";
    paths = [pkgs.nushell];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/nu \
        --add-flags "--config ${configs}/config.nu --env-config ${configs}/env.nu" \
        --set STARSHIP_CONFIG ${../configs/shells/starship/default.toml} \
        --prefix PATH : ${runtimeEnv}/bin
    '';
    passthru.shellPath = "/bin/nu";
    meta.mainProgram = "nu";
  }
