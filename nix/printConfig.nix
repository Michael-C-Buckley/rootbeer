{
  pkgs,
  name,
  cfg,
}:
pkgs.writers.writeNuBin name
# nu
''
  def --wrapped main [...args] {
    ${pkgs.bat}/bin/bat ...$args ${cfg}
  }
''
