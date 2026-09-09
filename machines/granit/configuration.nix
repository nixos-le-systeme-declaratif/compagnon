{ ... }:

{
  imports = [
    ./hardware-configuration.nix        # n'existe pas encore
    ./disques.nix
    ../../modules/socle.nix
    ../../modules/localisation.nix
    ../../modules/utilisateurs.nix
    ../../modules/outils.nix
    ../../modules/acces-distant.nix
  ];

  networking.hostName = "granit";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  mon.accesDistant.enable = true;

  users.users.sauvegarde = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA+UH+sVb7LK9WcGtu/KBBNzJi0Q6yRtHbq6LIj3SNlS sauvegarde@vitrine"
    ];
  };

  sops.defaultSopsFile = ../../secrets/granit.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  system.stateVersion = "26.05";
}
