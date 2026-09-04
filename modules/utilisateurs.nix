{ pkgs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.camille = import ../home.nix;

  programs.zsh.enable = true;

  users.users.camille = {
    isNormalUser = true;
    description = "Camille";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };
}
