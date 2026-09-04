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

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -lh";
      gs = "git status";
    };
    history.size = 50000;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      clock-show-weekday = true;
    };
  };

  home.stateVersion = "26.05";
}
