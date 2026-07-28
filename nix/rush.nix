{
  inputs,
  pkgs,
  ...
}: let
  shellEnv = import ./shellEnv.nix {inherit pkgs;};
in
  pkgs.symlinkJoin {
    name = "rush";
    paths = [inputs.rush.packages.${pkgs.stdenv.hostPlatform.system}.rush-shell];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/rush \
        --set ENV ${../configs/shells/rush/config.rush} \
        --prefix PATH : ${shellEnv}/bin
    '';
    passthru.shellPath = "/bin/rush";
  }
