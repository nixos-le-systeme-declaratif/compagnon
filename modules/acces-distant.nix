{ lib, config, ... }:

{
  options.mon.accesDistant.enable =
    lib.mkEnableOption "l'accès à la station par SSH";

  config = lib.mkIf config.mon.accesDistant.enable {
    services.openssh.enable = true;

    services.openssh.settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };

    users.users.camille.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB1uEAp7DAKRTI8/iGooncgqgbZKO2VBZNmz0eEwogZ/ camille@atelier"
    ];
    # la clé de VOTRE atelier : nix key generate-secret en tire une paire unique
    nix.settings.trusted-public-keys =
      [ "atelier-1:QdiwVMJWoLtG5JRfjFy5u8B9JaRxO84MbwXwWlfuHOk=" ];
  };
}
