{pkgs, ...}: let
  iproute2 =
    if pkgs.stdenv.isDarwin
    then [pkgs.iproute2mac]
    else if pkgs.stdenv.isLinux
    then [pkgs.iproute2]
    else [];

  common = builtins.attrValues {
    inherit iproute2;
    inherit
      (pkgs)
      # CLI
      bat
      eza
      fd
      fzf
      ripgrep
      # Utility
      direnv
      # Git
      git
      tig
      delta
      # Security
      sops
      age
      # Nix
      nix-tree
      nix-direnv
      ;
  };
in
  pkgs.buildEnv {
    name = "shell-buildenv";
    paths = common;
    pathsToLink = ["/bin"];
  }
