{ config, lib, pkgs, ... }:

{
  services.spice-vdagentd.enable = true;

  systemd.user.services.spice-vdagent-client = {
    description = "Spice guest session agent";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    unitConfig.StartLimitIntervalSec = 0;
    serviceConfig = {
      ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagent -x";
      Restart = "always";
      RestartSec = 2;
    };
  };

  # pont presse-papier Wayland -> X11 (invités Plasma)
  systemd.user.services.clipboard-wayland-to-x11 =
    lib.mkIf config.services.desktopManager.plasma6.enable {
      description = "Pont presse-papier Wayland -> X11 pour spice-vdagent";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      unitConfig.StartLimitIntervalSec = 0;
      serviceConfig = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${
          pkgs.writeShellScript "clip-to-x11" ''
            # ne pousse que si le contenu a changé : aucun rebond
            content="$(cat)"
            state="$XDG_RUNTIME_DIR/clip-bridge-last"
            [ -f "$state" ] && [ "$content" = "$(cat "$state")" ] && exit 0
            printf %s "$content" > "$state"
            printf %s "$content" | ${pkgs.xclip}/bin/xclip -selection clipboard
          ''
        }";
        Restart = "always";
        RestartSec = 2;
      };
    };
}
