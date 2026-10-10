{
  pkgs ? import <nixpkgs> { },
  extraPkgs ? [ ],
}:
pkgs.mkShellNoCC {
  name = "nvim-config";
  packages =
    with pkgs;
    [
      lefthook
      deadnix
      mdformat
      nil
      nixfmt
      selene
      statix
      stylua
      treefmt
      typos
    ]
    ++ extraPkgs;

  shellHook = ''
    if ! lefthook check-install >/dev/null 2>&1; then
      lefthook install
    fi
    git fetch
    git status --short --branch
  '';
}
