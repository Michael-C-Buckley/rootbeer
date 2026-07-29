# WIP
# Wrapped zsh
{pkgs, ...}: let
  shellEnv = import ./shellEnv.nix {inherit pkgs;};
  #printConfig = {
  #  name,
  #  cfg,
  #}:
  #  import ./printConfig.nix {inherit pkgs name cfg;};

  # zsh configs from the other part of this repo
  configs = ../configs/shells/zsh;

  zdotdir = pkgs.runCommand "zsh-zdotdir" {} ''
    mkdir -p "$out"
    ln -s ${configs}/zshenv "$out/.zshenv"
    ln -s ${configs}/zprofile "$out/.zprofile"
    ln -s ${configs}/zshrc "$out/.zshrc"
    ln -s ${configs}/abbreviations "$out/abbreviations"
  '';

  # printCfg = printConfig {
  #   name = "zsh-print-cfg";
  #   cfg = "${configs}/config.zsh";
  # };
  # printEnv = printConfig {
  #   name = "zsh-print-env";
  #   cfg = "${configs}/env.zsh";
  # };

  runtimeEnv = pkgs.buildEnv {
    name = "zsh-env";
    paths = builtins.attrValues {
      inherit
        shellEnv
        # printCfg
        # printEnv
        ;
      inherit
        (pkgs)
        fzf-zsh-plugin
        zsh-autosuggestions
        zsh-abbr
        ;
    };
  };
in
  pkgs.symlinkJoin {
    name = "zsh";
    paths = [pkgs.zsh];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/zsh \
        --set ZDOTDIR ${zdotdir} \
        --set STARSHIP_CONFIG ${../configs/shells/starship/default.toml} \
        --prefix PATH : ${runtimeEnv}/bin
    '';
    passthru.shellPath = "/bin/zsh";
    meta.mainProgram = "zsh";
  }
