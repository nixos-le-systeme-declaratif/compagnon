{ lib, config, ... }:

{
  options.mon.accesDistant.enable =
    lib.mkEnableOption "l'accès à la station par SSH";

  config = lib.mkIf config.mon.accesDistant.enable {
    services.openssh.enable = true;
  };
}
