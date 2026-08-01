{pkgs, ...}: let
  shellEnv = import ./shellEnv.nix {
    inherit pkgs;
    extraPkgs = [pkgs.zoxide];
  };
  configDir = ../configs/shells/fish;
in
  pkgs.symlinkJoin {
    name = "fish";
    paths = [pkgs.fish];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/fish \
        --add-flags "--init-command 'source ${configDir}/config.fish'" \
        --set fish_function_path \
          "${configDir}/functions;${pkgs.fish}/share/fish/functions" \
        --prefix PATH : ${shellEnv}/bin
    '';
    passthru.shellPath = "/bin/fish";
  }
