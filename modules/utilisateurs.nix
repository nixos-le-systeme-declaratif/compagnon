{ pkgs, ... }:

{
  programs.zsh.enable = true;

  users.users.camille = {
    isNormalUser = true;
    description = "Camille";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      ripgrep
      fd
      jq
      tree
    ];
  };
}
