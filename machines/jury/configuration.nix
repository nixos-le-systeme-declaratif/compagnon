{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disques.nix
    ../../modules/socle.nix
    ../../modules/localisation.nix
    ../../modules/utilisateurs.nix
    ../../modules/outils.nix
    ../../modules/acces-distant.nix
    ../../modules/certificats.nix
    ../../modules/executeur.nix
  ];

  networking.hostName = "jury";
  networking.hosts."192.168.122.97" = [ "vitrine" "forge" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  mon.accesDistant.enable = true;

  sops.defaultSopsFile = ../../secrets/jury.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  system.stateVersion = "26.05";
}
