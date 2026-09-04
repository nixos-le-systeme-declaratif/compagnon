{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    tree
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name  = "Camille";
      user.email = "camille@exemple.org";
      alias.st = "status";
      init.defaultBranch = "main";
    };
  };

  home.stateVersion = "26.05";
}
