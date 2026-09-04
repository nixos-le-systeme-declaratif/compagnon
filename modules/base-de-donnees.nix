{
  services.postgresql.enable = true;

  services.postgresql.ensureDatabases = [ "camille" ];
  services.postgresql.ensureUsers = [
    { name = "camille"; ensureDBOwnership = true; }
  ];
}
