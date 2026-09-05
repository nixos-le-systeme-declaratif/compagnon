{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep   # le vôtre, sans que la ligne le dise
    fd
    jq
    tree
    tomate    # citoyen de plein droit
  ];

  programs.git = {
    enable = true;
    package = pkgs.git.override { withLibsecret = true; };
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
