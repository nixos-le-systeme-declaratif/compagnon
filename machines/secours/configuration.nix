{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  networking.hostName = "secours";
  console.keyMap = "fr";

  # la clé de camille ouvre la porte — plus de sudo passwd dans l'urgence
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB1uEAp7DAKRTI8/iGooncgqgbZKO2VBZNmz0eEwogZ/ camille@atelier"
  ];
}
