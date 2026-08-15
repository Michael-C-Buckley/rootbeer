{pkgs, ...}: let
  shellEnv = import ./shellEnv.nix {
    inherit pkgs;
    extraPkgs = [pkgs.zoxide];
  };
  configDir = ../configs/shells/fish;
  fishScript =
    # fish
    ''
      #!${pkgs.fish}/bin/fish
      set -gx PATH ${shellEnv}/bin $PATH
      set fish_function_path ${configDir}/functions \
        ${pkgs.fish}/share/fish/functions
      exec ${pkgs.fish}/bin/fish --init-command 'source ${configDir}/config.fish' $argv
    '';
in
  pkgs.symlinkJoin {
    name = "fish";
    paths = [pkgs.fish];
    postBuild = ''
      rm -rf $out/bin/fish
      cat > "$out/bin/fish" <<'EOF'
      ${fishScript}
      EOF
      chmod +x $out/bin/fish
    '';
    passthru.shellPath = "/bin/fish";
  }
