{ ... }:
{
  name = "web-acces-reseau";

  nodes = {
    ouverte = {
      imports = [ ../modules/web.nix ];
      mon.web.accesReseau = true;
    };
    fermee = {
      imports = [ ../modules/web.nix ];
    };
    temoin = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.curl ];
    };
  };

  testScript = ''
    start_all()
    ouverte.wait_for_unit("nginx.service")
    fermee.wait_for_unit("nginx.service")

    ouverte.succeed("mkdir -p /srv/www && echo ouverte > /srv/www/index.html")
    fermee.succeed("mkdir -p /srv/www && echo fermee > /srv/www/index.html")

    temoin.succeed("curl --fail --max-time 5 http://ouverte/")
    temoin.fail("curl --fail --max-time 5 http://fermee/")
  '';
}
