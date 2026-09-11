{ config, pkgs, lib, ... }:

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
    ../../modules/certificats.nix
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
  networking.hosts."192.168.122.97" = [ "vitrine" "forge" ];
  networking.hosts."192.168.122.62" = [ "granit" ];

  sops.defaultSopsFile = ../../secrets/atelier.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets."nix/cle-signature" = { };

  nix.settings.secret-key-files =
    [ config.sops.secrets."nix/cle-signature".path ];

  sops.secrets."sauvegarde/mot-de-passe" = { };
  sops.secrets."sauvegarde/cle-ssh" = { };

  programs.ssh.knownHosts."granit".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGyb7wUGcg7RDKew2JHhgAKf1O1MI/vcVYUoDFggveBw";

  services.restic.backups.quotidienne = {
    repository = "sftp:sauvegarde@granit:atelier";
    passwordFile = config.sops.secrets."sauvegarde/mot-de-passe".path;
    extraOptions = [
      "sftp.command='ssh sauvegarde@granit -i ${config.sops.secrets."sauvegarde/cle-ssh".path} -s sftp'"
    ];
    paths = [ "/home/camille" ];
    exclude = [
      "/home/camille/.ssh"
      "/home/camille/.config/sops"
      "/home/camille/.cache"
    ];
    timerConfig = { OnCalendar = "02:30"; };
    initialize = true;
  };

  # L'accès distant
  mon.accesDistant.enable = true;

  # Le swap, déclaré : une clé neuve à chaque démarrage
  swapDevices = [{
    device = "/dev/disk/by-partlabel/swap";
    randomEncryption.enable = true;
  }];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [   # un kit de départ
    stdenv.cc.cc.lib   # libstdc++, libgcc_s — la demande n° 1
    openssl            # le TLS — sentinelle vous l'a réclamé
    zlib               # la compression — l'autre omniprésente
  ];

  virtualisation.vmVariant = {
    virtualisation.memorySize = 4096;
    users.users.camille = {
      hashedPasswordFile = lib.mkForce null;
      password = "brouillon";
    };
  };

  system.stateVersion = "26.05";  # (déjà présent) — ne changera plus jamais — voir l'encadré
}
