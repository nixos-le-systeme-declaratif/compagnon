{ config, mon-blog, ... }:

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

  services.postgresqlBackup = {
    enable = true;
    databases = [ "camille" "forgejo" ];
  };

  sops.secrets."sauvegarde/mot-de-passe" = { };
  sops.secrets."sauvegarde/cle-ssh" = { };

  networking.hosts."192.168.122.62" = [ "granit" ];

  programs.ssh.knownHosts."granit".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGyb7wUGcg7RDKew2JHhgAKf1O1MI/vcVYUoDFggveBw";

  services.restic.backups.quotidienne = {
    repository = "sftp:sauvegarde@granit:vitrine";
    passwordFile = config.sops.secrets."sauvegarde/mot-de-passe".path;
    extraOptions = [
      "sftp.command='ssh sauvegarde@granit -i ${config.sops.secrets."sauvegarde/cle-ssh".path} -s sftp'"
    ];
    paths = [ "/srv/www" "/var/backup/postgresql" "/var/lib/forgejo" ];
    timerConfig = { OnCalendar = "02:30"; };
    initialize = true;
  };

  services.nginx.virtualHosts."localhost".root =
    "${mon-blog}";

  sops.defaultSopsFile = ../../secrets/vitrine.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  system.stateVersion = "26.05";
}
