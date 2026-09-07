{ lib, config, ... }:

{
  options.mon.web.accesReseau =
    lib.mkEnableOption "la publication du site sur le réseau";

  config = {
    services.nginx.enable = true;

    services.nginx.virtualHosts."localhost" = {
      root = lib.mkDefault "/srv/www";
      default = true;
    };

    networking.firewall.allowedTCPPorts =
      lib.mkIf config.mon.web.accesReseau [ 80 ];
  };
}
