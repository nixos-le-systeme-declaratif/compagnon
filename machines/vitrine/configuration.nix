{
  imports = [
    ./hardware-configuration.nix        # n'existe pas encore — le corps le fournira
    ../../modules/socle.nix
    ../../modules/localisation.nix
    ../../modules/utilisateurs.nix
    ../../modules/outils.nix
    ../../modules/acces-distant.nix
    ../../modules/web.nix
    ../../modules/base-de-donnees.nix
    ../../modules/forge.nix
    ../../modules/certificats.nix
  ];

  networking.hostName = "vitrine";
  networking.hosts."192.168.122.33" = [ "atelier" ];
  networking.hosts."127.0.0.1" = [ "forge" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  swapDevices = [{
    device = "/dev/disk/by-partlabel/swap";  # elle non plus — le corps la creusera
    randomEncryption.enable = true;
  }];

  mon.accesDistant.enable = true;
  mon.web.accesReseau = true;
  mon.baseDeDonnees.accesReseau = true;

  sops.defaultSopsFile = ../../secrets/vitrine.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  system.stateVersion = "26.05";
}
