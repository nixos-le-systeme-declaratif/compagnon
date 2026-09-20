{ config, pkgs, ... }:

{
  sops.secrets."executeur/enrolement" = { };

  users.groups.executeur = { };

  sops.templates."executeur-netrc" = {
    content = ''
      machine forge
      login forgejo
      password ${config.sops.placeholder."forge/jeton"}
    '';
    group = "executeur";
    mode = "0440";
  };

  systemd.tmpfiles.rules = [
    "L+ /var/lib/gitea-runner/jury/.netrc - - - - ${config.sops.templates."executeur-netrc".path}"
  ];

  systemd.services.gitea-runner-jury.serviceConfig = {
    ExecPaths = [ "/var/lib/gitea-runner" ];
    SupplementaryGroups = [ "executeur" ];
  };

  virtualisation.podman.enable = true;

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances = {
      jury = {
        enable = true;
        name = "jury";
        url = "https://forge";
        tokenFile = config.sops.secrets."executeur/enrolement".path;
        labels = [ "nixos:host" ];
        hostPackages = with pkgs; [
          bash coreutils curl gawk gitMinimal gnutar gzip
          nodejs wget nix
        ];
      };

      conteneur = {
        enable = true;
        name = "jury-conteneur";
        url = "https://forge";
        tokenFile = config.sops.secrets."executeur/enrolement".path;
        labels = [ "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-22.04" ];
        settings.container = {
          options = "--add-host=forge:192.168.122.97 -v /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro";
          valid_volumes = [ "/etc/ssl/certs/ca-certificates.crt" ];
        };
      };
    };
  };
}
