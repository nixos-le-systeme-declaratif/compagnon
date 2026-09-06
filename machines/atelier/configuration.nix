{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/socle.nix
    ../../modules/localisation.nix
    ../../modules/utilisateurs.nix
    ../../modules/outils.nix
    ../../modules/acces-distant.nix
    ../../modules/web.nix
    ../../modules/base-de-donnees.nix
    ../../modules/bureau.nix
    ../../modules/machine-virtuelle.nix
  ];

  # Le démarrage
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Le noyau
  boot.kernelPackages = pkgs.linuxPackages;          # le LTS — la valeur par défaut
  # boot.kernelPackages = pkgs.linuxPackages_latest; # le dernier stable, pour le matériel trop neuf

  # L'identité
  networking.hostName = "atelier";
  networking.networkmanager.enable = true;
  networking.hosts."192.168.122.97" = [ "vitrine" ];

  sops.defaultSopsFile = ../../secrets/atelier.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # L'accès distant
  mon.accesDistant.enable = true;

  # Le swap, déclaré : une clé neuve à chaque démarrage
  swapDevices = [{
    device = "/dev/disk/by-partlabel/swap";
    randomEncryption.enable = true;
  }];

  system.stateVersion = "26.05";  # (déjà présent) — ne changera plus jamais — voir l'encadré
}
