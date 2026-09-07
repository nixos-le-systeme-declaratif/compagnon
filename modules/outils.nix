{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ git vim curl htop ncdu ];
}
