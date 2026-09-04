{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    tree
  ];

  home.stateVersion = "26.05";
}
