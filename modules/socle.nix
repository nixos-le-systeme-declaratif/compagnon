{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.overlays = [ (import ../overlays/retouches.nix) ];
}
