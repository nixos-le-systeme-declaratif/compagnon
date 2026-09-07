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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB7fq12KURubK0FIcTKk4YLYXpiw+pExbXSATPxe/cVm camille@vitrine"
    ];
  };
}
