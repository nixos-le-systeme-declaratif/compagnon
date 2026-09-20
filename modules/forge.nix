{ config, ... }:

{
  services.forgejo = {
    enable = true;

    database.type = "postgres";   # la base du chapitre précédent — jointe par la socket : même machine, zéro secret

    settings = {
      server = {
        DOMAIN = "forge";
        ROOT_URL = "https://forge/";
        HTTP_ADDR = "127.0.0.1";  # la forge n'écoute que chez elle — nginx expose
        HTTP_PORT = 3000;
      };
      service.DISABLE_REGISTRATION = true;   # forge privée : pas de guichet d'inscription
      actions.DEFAULT_ACTIONS_URL = "https://forge";
    };
  };

  sops.secrets."forge/cle-tls".owner = "nginx";

  services.nginx.virtualHosts."forge" = {
    forceSSL = true;
    sslCertificate = ../certificats/forge.pem;   # public — il vit au dépôt, comme l'autorité
    sslCertificateKey = config.sops.secrets."forge/cle-tls".path;
    locations."/".proxyPass = "http://127.0.0.1:3000";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];   # 80 ne sert plus qu'à rediriger

  environment.systemPackages = [ config.services.forgejo.package ];
}
