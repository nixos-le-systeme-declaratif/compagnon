{
  services.nginx.enable = true;

  services.nginx.virtualHosts."localhost" = {
    root = "/srv/www";
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
}
