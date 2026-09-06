{ lib, config, ... }:

{
  options.mon.baseDeDonnees.accesReseau =
    lib.mkEnableOption "l'accès à la base depuis le réseau";

  config = lib.mkMerge [
    {
      services.postgresql.enable = true;

      services.postgresql.ensureDatabases = [ "camille" ];
      services.postgresql.ensureUsers = [
        { name = "camille"; ensureDBOwnership = true; }
      ];
    }

    (lib.mkIf config.mon.baseDeDonnees.accesReseau {
      services.postgresql.enableTCPIP = true;
      services.postgresql.authentication = ''
        host all all 192.168.122.0/24 scram-sha-256
      '';
      networking.firewall.allowedTCPPorts = [ 5432 ];

      sops.secrets."bdd/camille".owner = "postgres";

      systemd.services.postgresql-setup.postStart = lib.mkAfter ''
        echo "ALTER ROLE camille PASSWORD '$(cat ${config.sops.secrets."bdd/camille".path})'" | psql --set ON_ERROR_STOP=1 -f -
      '';
    })
  ];
}
