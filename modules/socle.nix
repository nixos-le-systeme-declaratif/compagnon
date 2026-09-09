{ config, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.overlays = [ (import ../overlays/retouches.nix) ];
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  sops.secrets."forge/jeton" = {
    mode = "0440";
    group = "wheel";          # le démon (root) et les admins de la machine
  };

  programs.git = {
    enable = true;
    config = {
      credential."https://forge".username = "camille";
      credential."https://forge".helper =
        "!f() { [ \"$1\" = get ] && echo \"password=$(cat ${config.sops.secrets."forge/jeton".path})\"; }; f";
    };
  };
}
