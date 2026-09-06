{ config, pkgs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.camille = import ../home.nix;

  programs.zsh.enable = true;

  sops.secrets."camille/hashedPassword".neededForUsers = true;
  users.mutableUsers = false;

  users.users.camille = {
    isNormalUser = true;
    description = "Camille";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets."camille/hashedPassword".path;
  };
}
