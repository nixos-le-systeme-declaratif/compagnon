{ ... }:
{
  name = "web";

  nodes.machine = { ... }: {
    imports = [ ../modules/web.nix ];
  };

  testScript = ''
    machine.wait_for_unit("nginx.service")
    machine.succeed("mkdir -p /srv/www")
    machine.succeed("echo '<h1>test</h1>' > /srv/www/index.html")
    machine.succeed("curl --fail http://localhost/")
  '';
}
